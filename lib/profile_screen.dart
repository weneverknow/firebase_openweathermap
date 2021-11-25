import 'package:firebase_app/login_screen.dart';
import 'package:firebase_app/providers/member_provider.dart';
import 'package:firebase_app/providers/profile_provider.dart';
import 'package:firebase_app/providers/registration_provider.dart';
import 'package:firebase_app/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'providers/login_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Center(
                    child: Consumer<LoginProvider>(
                      builder: (context, loginProvider, _) =>
                          Consumer<RegistrationProvider>(
                              builder: (context, registrationProvider, _) {
                        print(
                            "loginProvider ${loginProvider.member?.imageUrl}");
                        print(
                            "registrationProvider ${registrationProvider.member?.imageUrl}");
                        return Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white54,
                              image: DecorationImage(
                                  image: NetworkImage(loginProvider
                                          .member?.imageUrl ??
                                      registrationProvider.member?.imageUrl ??
                                      'https://cdn.iconscout.com/icon/free/png-256/person-1767893-1502146.png'),
                                  fit: BoxFit.cover)),
                        );
                      }),
                    ),
                  ),
                  Center(
                    child: Consumer<LoginProvider>(
                      builder: (context, loginProvider, _) =>
                          Consumer<RegistrationProvider>(
                        builder: (context, registrationProvider, _) =>
                            registrationProvider.isLoading
                                ? Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.red.shade300,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 80,
                                    height: 95,
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () async {
                                        final file =
                                            await _imagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        if (file == null) return;
                                        registrationProvider.isLoading = true;
                                        final upload = await RegistrationService
                                            .uploadImage(file.path,
                                                name: file.name,
                                                phone: (loginProvider
                                                        .member?.phone ??
                                                    registrationProvider
                                                        .member?.phone ??
                                                    ''));
                                        if (upload != null) {
                                          if (loginProvider.member != null) {
                                            loginProvider.setMember(
                                                loginProvider.member!
                                                    .copyWith(imageUrl: null));
                                          }
                                          if (registrationProvider.member !=
                                              null) {
                                            registrationProvider.member =
                                                registrationProvider.member!
                                                    .copyWith(imageUrl: null);
                                          }

                                          if (registrationProvider.member !=
                                              null) {
                                            registrationProvider.member =
                                                registrationProvider.member!
                                                    .copyWith(imageUrl: upload);
                                          }
                                          if (loginProvider.member != null) {
                                            loginProvider.setMember(
                                                loginProvider.member!.copyWith(
                                                    imageUrl: upload));
                                          }
                                          print("upload successfully");
                                          print(upload);
                                        }
                                        registrationProvider.isLoading = false;
                                        //print("file " + file.path);
                                        //print("name " + file.name);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: const Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Phone',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    Consumer<LoginProvider>(
                      builder: (context, loginProvider, _) =>
                          Consumer<RegistrationProvider>(
                        builder: (context, registrationProvider, _) => Text(
                          loginProvider.member?.phone ??
                              registrationProvider.member?.phone ??
                              '-',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontSize: 12),
                        ),
                        Consumer<ProfileProvider>(
                          builder: (context, profileProvider, _) =>
                              Consumer<LoginProvider>(
                            builder: (context, loginProvider, _) =>
                                Consumer<RegistrationProvider>(
                              builder: (context, registrationProvider, _) =>
                                  GestureDetector(
                                onTap: () {
                                  profileProvider.setNameController(
                                      loginProvider.member?.name ??
                                          registrationProvider.member?.name ??
                                          '-');
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Name'),
                                                const SizedBox(height: 10),
                                                Consumer<ProfileProvider>(
                                                  builder:
                                                      (context, provider, _) =>
                                                          TextField(
                                                    controller:
                                                        provider.nameController,
                                                    decoration: InputDecoration(
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white54,
                                                                    width:
                                                                        0.6)),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .white54,
                                                                    width:
                                                                        0.6))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child:
                                                      Consumer<LoginProvider>(
                                                    builder: (context,
                                                            loginProvider, _) =>
                                                        Consumer<
                                                            RegistrationProvider>(
                                                      builder: (context,
                                                              registrationProvider,
                                                              _) =>
                                                          Consumer<
                                                              ProfileProvider>(
                                                        builder:
                                                            (context, provider,
                                                                    _) =>
                                                                provider
                                                                        .isLoading
                                                                    ? Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color: Colors
                                                                              .red
                                                                              .shade300,
                                                                          strokeWidth:
                                                                              0.6,
                                                                        ),
                                                                      )
                                                                    : ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 30),
                                                                            primary: Colors.white54,
                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            side: const BorderSide(color: Colors.white54, width: 0.6)),
                                                                        onPressed: () async {
                                                                          provider
                                                                              .changeLoading();
                                                                          final update = await RegistrationService.updateMemberName(
                                                                              (loginProvider.member?.phone ?? registrationProvider.member?.phone ?? ''),
                                                                              provider.nameController.text);

                                                                          await Future.delayed(
                                                                              const Duration(seconds: 1));
                                                                          loginProvider
                                                                              .setMember((loginProvider.member ?? registrationProvider.member)!.copyWith(name: provider.nameController.text));
                                                                          registrationProvider.member =
                                                                              (loginProvider.member ?? registrationProvider.member)!.copyWith(name: provider.nameController.text);
                                                                          provider
                                                                              .changeLoading();
                                                                          Navigator.pop(
                                                                              context);
                                                                          if (update) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Successfully')));
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Successfully')));
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                          'Save',
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.green.shade200,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Consumer<LoginProvider>(
                      builder: (context, loginProvider, _) =>
                          Consumer<RegistrationProvider>(
                        builder: (context, registrationProvider, _) => Text(
                          loginProvider.member?.name ??
                              registrationProvider.member?.name ??
                              '-',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 1,
                child: const Divider(
                  color: Colors.white30,
                  indent: 20,
                  endIndent: 20,
                  height: 0.5,
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                title: const Text('Change your pin'),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pin'),
                                const SizedBox(height: 10),
                                Consumer<ProfileProvider>(
                                  builder: (context, provider, _) => TextField(
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    controller: provider.pinController1,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white54,
                                                width: 0.6)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white54,
                                                width: 0.6))),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('Pin Confirmation'),
                                const SizedBox(height: 10),
                                Consumer<ProfileProvider>(
                                  builder: (context, provider, _) => TextField(
                                    obscureText: true,
                                    controller: provider.pinController2,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white54,
                                                width: 0.6)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.white54,
                                                width: 0.6))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Consumer<LoginProvider>(
                                    builder: (context, loginProvider, _) =>
                                        Consumer<RegistrationProvider>(
                                      builder:
                                          (context, registrationProvider, _) =>
                                              Consumer<ProfileProvider>(
                                        builder: (context, provider, _) => provider
                                                .isLoading
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.red.shade300,
                                                  strokeWidth: 0.6,
                                                ),
                                              )
                                            : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 30),
                                                    primary: Colors.white54,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    side: const BorderSide(
                                                        color: Colors.white54,
                                                        width: 0.6)),
                                                onPressed: () async {
                                                  if (provider.pinController1
                                                          .text.isEmpty ||
                                                      provider.pinController2
                                                          .text.isEmpty) {
                                                    return;
                                                  }
                                                  if (provider.pinController1
                                                          .text !=
                                                      provider.pinController2
                                                          .text) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Pin must be same.')));
                                                    return;
                                                  }

                                                  if (provider.pinController1
                                                              .text.length <
                                                          6 ||
                                                      provider.pinController2
                                                              .text.length <
                                                          6) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Pin must have 6 digits')));
                                                    return;
                                                  }
                                                  provider.changeLoading();
                                                  final update =
                                                      await RegistrationService
                                                          .updatePin(
                                                              (loginProvider
                                                                      .member
                                                                      ?.phone ??
                                                                  registrationProvider
                                                                      .member
                                                                      ?.phone ??
                                                                  ''),
                                                              provider
                                                                  .pinController1
                                                                  .text
                                                                  .trim());

                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1));

                                                  provider.changeLoading();
                                                  Navigator.pop(context);
                                                  if (update) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Update Successfully')));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Update Failed')));
                                                  }
                                                },
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
              Consumer<LoginProvider>(
                builder: (context, provider, _) => ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  title: const Text('Logout'),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    provider.logout();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                ),
              )
            ],
          ),
        ));
  }
}
