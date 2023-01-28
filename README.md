# Spam Filter

### Update Status  
ML - Version 2.0: android on-device implementation improvements  
Android - Version 1.0: first production ready android app  
iOS - Version N/A: future work + research and feasibility checks not satisified yet  

## Introduction

### Problem
Spam messages can lead to loss of personal information. Scammers use different tactics to steal personal information. Scammers may send you a link to an existing website or app of a popular company to steal your information or make money from in-app purchases. For example, these spam messages often include malicious links and when the victim clicks the link, it downloads malware to their device. Scammers can then have access to the victim’s personal data which can include their name, address, and SSN or their financial data such as credit card numbers or bank information. This can lead to identity theft.

### Our Solution

To prevent this growing problem, Spam Filter is designed to detect and respond to these spam messages. The user can choose different remediation techniques to deal with the spam messages. This can include being notified of a spam message, removing spam messages, or automatically blocking the number where the message came from. Blocked numbers are stored in the black list and the white list consists of numbers to ignore such as the user’s named contacts. If the model makes a mistake, the user can choose to edit the numbers in the list or to retrain the model on their device.

## UI Design

Our initial page is called the inbox page where users can read recently received messages. It also has NavBar where they can navigate to different screens such as, info, track, test, and setting.

![InboxScreen](https://user-images.githubusercontent.com/63376460/208818307-1794b3b7-3a44-4ca7-858a-9563c1ca6cdc.gif)

The Settings screen has a toggle button to enable or disable settings such as notification, auto block, whitelist contact, blacklist messages and delete spam messages. It also has a slider which users can set qualifiers for their model. Icon button to reset the model.

![Setting Screen](https://i.imgur.com/T8lrYpA.png)

Info screen has two toggle button chat and spam. Chat shows messages that are not spam and spam shows spam messages. Users can click on those messages and it will display a dialog where users will be able to see the full message and can train the model by clocking the train model and there is also a check box to label if the message is spam or not.

![InfoScreen](https://user-images.githubusercontent.com/63376460/208818332-ff60554c-ab04-4d6e-87af-31255f242b2d.gif)

Safe has two toggle buttons Whitelist and Blacklist. There is a bottom floating action button at the bottom where users can add numbers.  There are two buttons next to the number cross icon is to delete number and refresh icon button is to swap from whitelist to blacklist, vice versa.

Search Screen has two toggle buttons Test and Train and Text Field for users to test or train their model. There is a submit button below the text Field for users to see the result of train or test.

![ReTrainingScreen](https://user-images.githubusercontent.com/63376460/208818358-29970acd-5abf-4a2b-8f07-2ed6dbb2d144.gif)

## Software Design

There were many features in our app, us to experiment with these features we needed a User Interface. We had to design the app first and develop the app using default values to make sure each of the feature major components were complete. Once we completed our user interface then were able to test our backend function by replacing the default values. We did test run our backend function in a separate app to avoid dealing with errors and debugging the code in our main application. There were a few times we had to face some difficulties we had to face when we tried to  run a machine learning model on our app, so we experimented with the model and fixed those errors on a separate app.

The application can automatically block a phone number iif the model detects the message is spam. Works while the application is in foreground, background or even closed. The user can disable or enable notifications for text messages depending on their preference. The application can automatically delete a  message if the model detects the message is spam. Works while the application is foreground, background or closed.

### Tunnel Diagram of Application

![Tunnel Diagram of Application](https://i.imgur.com/cESEdgU.png)

The frontend is created using Flutter which provides a user-friendly experience. Most of our backend functionality is from Android such as using Blocking, Notifications, Shared Preferences to store the settings that the user modifies, and most importantly, Receivers. Receivers allows our app to be automatic or run even when it is closed. We put our Remediation logic in our receivers to handle incoming sms (and/or mms) messages the way the user chooses. Of course, our remediation techniques rely on the prediction of our model. For this, we run python code for our model directly on the Android device using a library called Chaquopy. This is very powerful as it also allows the user to retrain the model to their liking.

## ML Design

### Dataset

We used the [SMS Spam Collection Dataset](https://www.kaggle.com/datasets/uciml/sms-spam-collection-dataset) from Kaggle. This dataset has 5,574 rows of data and two relevant columns; text and type. The text field includes the raw text of the sms message and the type field is the label indicating whether or not the sms message is spam or ham (legitimate). 

The dataset is also in our repository over [here](https://github.com/AzwadShameem/SMS_Filter_App/blob/machine-learning/Data/spam.csv).

### Experiments

The table below shows the testing accuracy, precision, recall, and PR-AUC of our `SMSClassifier` model with different Embedding Sizes and Data Processing methods. 

| Dataset | Embedding Size | Accuracy | Precision | Recall | PR_AUC |
| - | - | - | - | - | - |
| Undersampled | 8 | 0.9290322580645162 | 0.9714285714285714 | 0.8831168831168831 | 0.940186090834039 | 
| Undersampled | 16 | 0.9483870967741935 | 0.9726027397260274 | 0.922077922077922 | 0.9666951696116521 | 
| Undersampled | 32 | 0.9741935483870968 | 0.9506172839506173 | 1.0 | 0.9753086419753086 | 
| Oversampled | 8 | 0.9979296066252588 | 0.9958762886597938 | 1.0 | 0.9979381443298969 | 
| Oversampled | 16 | 0.994824016563147 | 0.9897540983606558 | 1.0 | 0.9948770491803278 | 
| Oversampled | 32 | 0.9968944099378882 | 0.9938271604938271 | 1.0 | 0.9969135802469136 | 

From these experiments above, we notice that Oversampling performs better than Understampling and that increasing the Embedding Size increases the performance metrics.

Thus, it is no suprise we use the model trained with the Oversampled dataset with an Embedding Size of 32 in our current app.
## Run these experiments yourself!

Get started running our machine learning experiments!

#### Prerequisites
- [Python 3.8+](https://www.python.org/downloads/)
    - Python and pip are required to install dependencies such as PyTorch, tensorflow, nltk, and etc. 
- [Jupyter Notebook](https://jupyter.org/install) (Reccomended)
    - A way to run `.ipynb` files is required however
    - Learn how to install Python and Jupyter Notebook from the [official documentation](https://docs.jupyter.org/en/latest/install.html#new-to-python-and-jupyter) which also includes tips and tutorials

1. Assuming that everything above works as intended, begin by cloning this repository
```
git clone https://github.com/AzwadShameem/SMS_Filter.git
```
2. Switch to our software engineering branch
```
git checkout machine-learning
```

3. Choose an `.ipynb` file to open in Jupyter Notebook (or whatever IDE you prefer). In this example you can open `advanced_lstm.ipynb` under the PyTorch directory or view it [here](https://github.com/AzwadShameem/SMS_Filter_App/blob/machine-learning/PyTorch/advanced_lstm.ipynb)
```
open /PyTorch/advanced_lstm.ipynb
```

4. When a dependency comes up that has not been installed yet such as PyTorch, simply install it as such as rerun the cell containing the imports. Repeat this process for as many imports needed.
```
pip install torch
pip install nltk
pip install [...]
```
5. Enjoy our running our LSTM experiments!
    - You can press `ctrl + enter` to run individual cells one by one or click on the play symbol by next to the cell.

Note that we use [Magic Commands](https://ipython.readthedocs.io/en/stable/interactive/magics.html) so that files do have to be ran one by one but if you are interested in following along with the experiments, follow our guide below:

1. Switch to the [Data](https://github.com/AzwadShameem/SMS_Filter/tree/machine-learning/data) directory
    - The original dataset is called `spam.csv`
2. Open `class_imbalance.ipynb` to generate `undersampled_spam.csv` and `oversampled_spam.csv`
3. Check out our [Model](https://github.com/AzwadShameem/SMS_Filter/tree/machine-learning/models) directory and see the pretrained models we have provided for you!
    - We have included models trained on our Undersampling and Oversampling datasets with 3 different Embedding Sizes (8, 16, and 32)
    - Note that you can train your own models in `smsclassifier.ipynb` under the PyTorch directory for LSTM models with an embedded size of your own choosing
5. Switch to the PyTorch directory and open `loader.ipynb`
    - This file splits the dataset into batches for training and testing after preprocessing 
6. Open `advanced_lstm` and have fun running our experiments 





## Documentation

### Code Organization
- The [Machine Learning](https://github.com/AzwadShameem/SMS_Filter/tree/machine-learning) branch of this repository contains all of the machine learning related code
- The [Android](https://github.com/AzwadShameem/SMS_Filter/tree/android) branch of this repository contains all of the android software engineering related code
- The [iOS](https://github.com/AzwadShameem/SMS_Filter/tree/iOS) branch of this repository contains all of the iOS software engineering related code

### Installation

Get Started running our Spam Filter app

#### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
    - For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev), which offers tutorials, samples, guidance on mobile development, and a full API reference.
    - To make sure flutter is successfully installed and ready to use, run `flutter doctor` and ensure there are no errors 
- [Android Studio](https://developer.android.com/studio/install)
    - Start Android Studio, and go through the `Android Studio Setup Wizard`. This installs the latest Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android
- [Android Emulator](https://developer.android.com/studio/run/managing-avds)
    1. Launch Android Studio, click the AVD Manager icon, and select Create Virtual Device…
    2. Choose a device definition
    3. Select a system images for the Android versions you want to emulate (x86 or x86_64 image is recommended)
    4. Verify the AVD configuration is correct, and select Finish
    5. In Android Virtual Device Manager, click Run in the toolbar. The emulator will start up and display the system image chosen

- [Python 3.8+](https://www.python.org/downloads/)
    - Ensure that a python version is in your PATH environment variable (This is very important)

1. Assuming that everything above works as intended, begin by starting up your Android Emulator. 
2. Clone this repository
```
git clone https://github.com/AzwadShameem/SMS_Filter.git
```
3. Switch to our software engineering branch
```
git checkout android
```
4. Run our flutter application
```
flutter run
```
5. Select your Android Emulator at the prompt
6. Enjoy our app!

## Challenges Faced

### Inadequate Data

One of the major challenges we faced was with the quantity and quality of our dataset. Our dataset only had 5.5k spam messages with the majority being legitimate messages. In previous experiments, this was a problem as when we plotted the confustion matrices of our older models, we noticed that it predicted wrong when the true label was spam as opposed to when the true label was ham (legitimate). To manage the class imbalance issue in our dataset, we looked into Undersampling and Oversampling to balance our classes. We found that Oversampling was better than Undersampling which makes sense as Undersampling removes data to balance our classes which causes a loss of important information that our models could have used.

### Feature Engineering

Our machine learning problem is an NLP problem and one of the biggest challenges is finding a good method to turn text into numbers that a model can understand. At first, we manually extracted features out of the text. This included getting the length of the text, counting how many words there are, checking if there is any punctuation, and any other features we could think. Of course, this was a bad idea in many ways. One of them is that it was a lot of work for the programmer to think of good features to extract. Ideally, we want the model to do this hard work for us. Our next approach was using a form of One Hot Encoding. This worked by populating a vector of the vocabulary with a `1` if it was in the text message. This solved our previous problem but this idea has its own issue. It was very inefficient. Our vocabulary was about 8k words which meant that our vectors were mostly empty especially if we had shorter text messages. Our solution was to use Word Embedding which makes our vectors much more spares and solves the issues we have been having with our previous methods. Word Embedding essentially works by converting each of the words in a text into its own vector of a specified size. The best part about Word Embedding is that these vectors are trainable parameters which means that our model can figure out the best mapping of words to vectors for us.

## Future Work

### Improve Dataset

The dataset we used is a few years old and newer spam messages may use newer and more modern techniques which our models may not recognize the pattern of. We hope that our on-device training feature can mitigate this issue. We would like many more examples of spam messages especially in the world today. 

### Server Databases

One way to solve the issue above is to ask our users to fill out a survey if they are willing to share examples of their spam or legitimate text message. We can aggregate the messages the users share with us into a large database so that we can improve the base model included in our app. This should help us combat spam messages as they evolve over time. 

Another feature that this functionality could provide us is creating what we call the Scarlet List. This would simply be a table that stores blocked numbers between all the users of our app. This way, our Black List can be initalized with some numbers in the Scarlet List.


### Decrease Space

The dependencies that our app relies on can increase the bundle size of our app significantly. One of our challenges was finding a balance between a good performing model that is large or a worse performing that is smaller. To make our app avaliable to the most users, we may start simple by adjusting this line more. A more complex way would be to reconsider some of our dependencies and try not use them or replace them with something that takes up less space.


### Themes

We gotta have a dark mode.
