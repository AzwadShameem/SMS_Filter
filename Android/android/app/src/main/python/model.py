import torch
import nltk
import string
from dictionary import dictionary as dictionary
from stopwords import stopwords as stopwords


class SMSClassifier(torch.nn.ModuleList):
    def __init__(self, dictionary_len=len(dictionary) + 1, embedding_dim=32, num_layers=2, padding_idx=0, dropout=0.5):
        super(SMSClassifier, self).__init__()
        self.embedding_layer = torch.nn.Embedding(num_embeddings=dictionary_len, embedding_dim=embedding_dim, padding_idx=padding_idx)
        self.lstm_layer = torch.nn.LSTM(input_size=embedding_dim, hidden_size=embedding_dim, num_layers=num_layers, dropout=dropout, batch_first=True, bidirectional=True)
        self.maxpool_layer = torch.nn.MaxPool1d(kernel_size=8)
        self.linear_layer1 = torch.nn.Linear(int(embedding_dim / 2), out_features=int(embedding_dim / 4))
        self.dropout_layer = torch.nn.Dropout(dropout)
        self.linear_layer2 = torch.nn.Linear(int(embedding_dim / 4), 1)
        self.sigmoid_layer = torch.nn.Sigmoid()

    def preprocess(self, sentence):
        wordVector = []
        for word in sentence.lower().split():
            # TODO: USE REGEX TO INCREASE WEBSITE DETECTION COMPLEXITY
            # Website Case
            if 'www.' in word or 'http:' in word:
                wordVector.append(dictionary['[website]'])
            else:
                i = 0
                while i < len(word):
                    # Word Case
                    if 'a' <= word[i] <= 'z':
                        # Get the whole word
                        newWord = ''
                        while i < len(word) and 'a' <= word[i] <= 'z':
                            newWord += word[i]
                            i += 1
                        # Stem the whole word
                        newWord = nltk.stem.PorterStemmer().stem(newWord)
                        # Disregard if stopword
                        if newWord not in stopwords:
                            if newWord in dictionary:
                                wordVector.append(dictionary[newWord])
                            else:
                                wordVector.append(dictionary['[unknown]'])
                    elif '0' <= word[i] <= '9':
                        # Number case --> Attempt to append whole number including decimals
                        while i < len(word) and '0' <= word[i] <= '9':
                            if i + 2 < len(word):
                                # Makes sure the number encompasses decimals
                                if word[i + 1] == '.' or word[i + 1] == '-' and '0' <= word[i + 2] <= '9':
                                    i += 3
                                else:
                                    i += 1
                            else:
                                i += 1
                        wordVector.append(dictionary['[number]'])
                    elif word[i] in string.punctuation:
                        # Punctuation Case
                        if word[i] == '.' or word[i] == '-' and i + 1 < len(word):
                            # Special Punctuation Case example: ".9"
                            i += 1
                            while i < len(word) and '0' <= word[i] <= '9':
                                # Loop through whole number
                                if i + 2 < len(word):
                                    # Makes sure the number encompasses decimals
                                    if word[i + 1] == '.' or word[i + 1] == '-' <= word[i + 2] <= '9':
                                        i += 3
                                    else:
                                        i += 1
                                else:
                                    i += 1
                            wordVector.append(dictionary['[number]'])
                        else:
                            wordVector.append(dictionary[word[i]])
                            i += 1
                    else:
                        # Special Case - unknown characteras disregarded (no support)
                        i += 1
        if len(wordVector) == 0:
            return [dictionary['[empty]']]
        return wordVector

    def forward(self, sms):
        sms = torch.IntTensor([self.preprocess(sms)])
        embedding_layer = self.embedding_layer(sms)
        lstm_layer, (hidden, cell) = self.lstm_layer(embedding_layer)
        hidden_layer = torch.cat((hidden[0], hidden[1]), dim=1)
        cell_layer = torch.cat((cell[0], cell[1]), dim=1)
        lstm_layer = torch.cat((hidden_layer, cell_layer), dim=1)
        lstm_layer = torch.reshape(lstm_layer.unsqueeze(-1), (1, 1, lstm_layer.shape[1]))
        maxpool_layer = self.maxpool_layer(lstm_layer)
        linear_layer1 = self.linear_layer1(maxpool_layer)
        relu_layer = torch.relu_(linear_layer1)
        dropout_layer = self.dropout_layer(relu_layer)
        linear_layer2 = self.linear_layer2(dropout_layer)
        sigmoid_layer = self.sigmoid_layer(linear_layer2)
        output_layer = sigmoid_layer.squeeze()
        return torch.reshape(output_layer, (-1,))

    def load(self, path):
        self.load_state_dict(torch.load(path, map_location=torch.device('cpu')))

    def save(self, path):
        torch.save(self.state_dict(), path)

    def predict(self, sms):
        with torch.no_grad():
            self.eval()
            return self.forward(sms).item()

    def fit(self, sms, label, epochs):
        optimizer, loss_fn = torch.optim.Adam(self.parameters(), lr=1e-3), torch.nn.BCELoss()
        self.train()
        for epoch in range(epochs):
            prediction = self.forward(sms)
            train_loss = loss_fn(prediction, torch.FloatTensor([label]))
            optimizer.zero_grad()
            train_loss.backward()
            torch.nn.utils.clip_grad_norm_(self.parameters(), max_norm=2.0, norm_type=2)
            optimizer.step()


def getAssets():
    try:
        nltk.data.find('tokenizers/punkt')
    except LookupError:
        nltk.download('punkt')


def predict(path, smsList):
    predictions = []
    model = SMSClassifier()
    model.load(path)
    for sms in smsList:
        predictions.append(model.predict(sms) * 100)
    return predictions


def train(path, sms, label, epochs):
    curr_pred, new_pred = 0, 0
    model = SMSClassifier()
    model.load(path)
    curr_pred = model.predict(sms)
    model.fit(sms, label, epochs)
    new_pred = model.predict(sms)
    model.save(path)
    return f'{curr_pred * 100:.2f}% --> {new_pred * 100:.2f}%'


def reset(curr_path, original_path):
    model = SMSClassifier()
    model.load(original_path)
    model.save(curr_path)
    return model
