import 'package:feather_icons/feather_icons.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spam_filter/constants.dart';
import 'package:spam_filter/provider/settingProvider.dart';

class SettingsInfo extends StatelessWidget {
  const SettingsInfo({
    Key? key,
  }) : super(key: key);

  Future loadSettings(context) async {
    SettingProvider settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    settingProvider.updateNotification(await const MethodChannel("Android")
            .invokeMethod("getSettings", ["notifications", "true"]) ==
        "true");
    settingProvider.updateWhiteListContact(await const MethodChannel("Android")
            .invokeMethod("getSettings", ["whiteList-contacts", "true"]) ==
        "true");
    settingProvider.updateQualifier(double.parse(await const MethodChannel("Android").invokeMethod("getSettings", ["qualifier", "50"]))/100);
    if (await const MethodChannel("Android").invokeMethod("isDefault")) {
      settingProvider.updateAutoBlock(await const MethodChannel("Android")
              .invokeMethod("getSettings", ["auto-block", "false"]) ==
          "true");
      settingProvider.updateDeleteSpamMessages(
          await const MethodChannel("Android")
                  .invokeMethod("getSettings", ["auto-delete", "false"]) ==
              "true");
      settingProvider.updateBlackListMessages(
          await const MethodChannel("Android").invokeMethod(
                  "getSettings", ["blackList-blocked", "false"]) ==
              "true");
    } else {
      settingProvider.updateAutoBlock(await const MethodChannel("Android")
              .invokeMethod("setSettings", ["auto-block", "false"]) ==
          "true");
      settingProvider.updateDeleteSpamMessages(
          await const MethodChannel("Android")
                  .invokeMethod("setSettings", ["auto-delete", "false"]) ==
              "true");
      settingProvider.updateBlackListMessages(
          await const MethodChannel("Android").invokeMethod(
                  "setSettings", ["blackList-blocked", "false"]) ==
              "true");
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider =
        Provider.of<SettingProvider>(context, listen: true);
    loadSettings(context);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      // ignore: prefer_const_literals_to_create_immutables
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SettingMenuItem(
          title: "Notifications",
          icon: FeatherIcons.bellOff,
          isActive: settingProvider.notification,
        ),
        SettingMenuItem(
          title: "Auto Block",
          icon: FeatherIcons.check,
          isActive: settingProvider.autoBlock,
        ),
        SettingMenuItem(
          title: "Auto Delete",
          icon: FeatherIcons.trash2,
          isActive: settingProvider.deleteSpamMessages,
        ),
        SettingMenuItem(
          title: "Whitelist Contacts",
          icon: Icons.people,
          isActive: settingProvider.whiteListContact,
        ),
        SettingMenuItem(
          title: "BlackList Blocked",
          icon: FeatherIcons.messageSquare,
          isActive: settingProvider.blackListMessages,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xffE3E7EB),
              ),
              child: Text(
                settingProvider.qualifier.toString().substring(0, 3), style: TextStyle(fontSize: 16, color: kPrimaryColor)
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "Qualifier",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Quicksand",
              ),
            ),
            const Spacer(),
            Slider(
                value: settingProvider.qualifier,
                onChanged: (val) async {
                  settingProvider.updateQualifier(val);
                  await const MethodChannel("Android").invokeMethod("setSettings", ["qualifier", (val*100).toString()]);
                })
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xffE3E7EB),
              ),
              child: const Icon(
                FeatherIcons.file,
                size: 20,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "Reset Model",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Quicksand",
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  await const MethodChannel("Android").invokeMethod("reset");
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.teal,
                  size: 30,
                ))
          ],
        )
      ]),
    );
  }
}

class SettingMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  const SettingMenuItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xffE3E7EB),
            ),
            child: Icon(
              icon,
              size: 20,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Quicksand",
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: 3 / 2,
            child: Switch(
                activeColor: Colors.teal,
                value: isActive,
                onChanged: (val) async {
                  SettingProvider settingProvider =
                      Provider.of<SettingProvider>(context, listen: false);
                  if (title == "Notifications") {
                    settingProvider.updateNotification(
                        await const MethodChannel("Android").invokeMethod(
                                "setSettings",
                                ["notifications", val.toString()]) ==
                            "true");
                  } else if (title == "Auto Block") {
                    if (val) {
                      if (await const MethodChannel("Android")
                          .invokeMethod("isDefault")) {
                        settingProvider.updateAutoBlock(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings", ["auto-block", "true"]) ==
                                "true");
                      } else {
                        bool isDefault = await const MethodChannel("Android")
                            .invokeMethod("setDefault");
                        settingProvider.updateAutoBlock(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings",
                                    ["auto-block", isDefault.toString()]) ==
                                "true");
                      }
                    } else {
                      settingProvider.updateAutoBlock(
                          await const MethodChannel("Android").invokeMethod(
                                  "setSettings", ["auto-block", "false"]) ==
                              "true");
                    }
                  } else if (title == "Auto Delete") {
                    if (val) {
                      if (await const MethodChannel("Android")
                          .invokeMethod("isDefault")) {
                        settingProvider.updateDeleteSpamMessages(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings", ["auto-delete", "true"]) ==
                                "true");
                      } else {
                        bool isDefault = await const MethodChannel("Android")
                            .invokeMethod("setDefault");
                        settingProvider.updateDeleteSpamMessages(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings",
                                    ["auto-delete", isDefault.toString()]) ==
                                "true");
                      }
                    } else {
                      settingProvider.updateDeleteSpamMessages(
                          await const MethodChannel("Android").invokeMethod(
                                  "setSettings", ["auto-delete", "false"]) ==
                              "true");
                    }
                  } else if (title == "Whitelist Contacts") {
                    settingProvider.updateWhiteListContact(
                        await const MethodChannel("Android").invokeMethod(
                                "setSettings",
                                ["whiteList-contacts", val.toString()]) ==
                            "true");
                  } else if (title == "BlackList Blocked") {
                    if (val) {
                      if (await const MethodChannel("Android")
                          .invokeMethod("isDefault")) {
                        settingProvider.updateBlackListMessages(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings",
                                    ["blackList-blocked", "true"]) ==
                                "true");
                      } else {
                        bool isDefault = await const MethodChannel("Android")
                            .invokeMethod("setDefault");
                        settingProvider.updateBlackListMessages(
                            await const MethodChannel("Android").invokeMethod(
                                    "setSettings", [
                                  "blackList-blocked",
                                  isDefault.toString()
                                ]) ==
                                "true");
                      }
                    } else {
                      settingProvider.updateBlackListMessages(
                          await const MethodChannel("Android").invokeMethod(
                                  "setSettings",
                                  ["blackList-blocked", "false"]) ==
                              "true");
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
