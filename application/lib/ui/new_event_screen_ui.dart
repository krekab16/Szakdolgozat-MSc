import 'package:application/utils/input_box.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/my_button.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/new_event_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user_model.dart';
import 'dart:io';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  File? _imageFile;
  String? selectedCategory;

  void _showDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((time) {
          if (time != null) {
            final selectedDateTime = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
            setState(() {
              dateController.text =
                  DateFormat.yMMMd().add_Hm().format(selectedDateTime);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final newEventScreenViewModel =
        Provider.of<NewEventScreenViewModel>(context);
    final userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          newEvent,
          style: Styles.textStyles,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputBox(
                const Icon(
                  Icons.create_rounded,
                ),
                newEventName,
                (newEventName) => newEventScreenViewModel.setName(newEventName),
                (value) => newEventScreenViewModel.validateName(value!),
              ),
              InputBox(
                const Icon(
                  Icons.create_rounded,
                ),
                newEventAddress,
                (newEventAddress) =>
                    newEventScreenViewModel.setAddress(newEventAddress),
                (value) => newEventScreenViewModel.validateAddress(value!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value: selectedCategory,
                  items: newEventScreenViewModel.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: newEventCategory,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.category_outlined,
                    ),
                  ),
                  onChanged: (selectedCategory) =>
                      newEventScreenViewModel.setCategory(selectedCategory!),
                  validator: (selectedCategory) =>
                      newEventScreenViewModel.validateCategory(selectedCategory),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _showDateTimePicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: newEventDate,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.date_range_rounded,
                        ),
                      ),
                      validator: (value) =>
                          newEventScreenViewModel.validateDate(value!),
                    ),
                  ),
                ),
              ),
              InputBox(
                  const Icon(
                    Icons.create_rounded,
                  ),
                  newEventStuffLimit,
                  (newEventStuffLimit) => newEventScreenViewModel
                      .setStuffLimit(int.parse(newEventStuffLimit)),
                  (value) =>
                      newEventScreenViewModel.validateStuffLimit(value!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: newEventDescription,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.create_rounded,
                    ),
                  ),
                  onChanged: (newEventDescription) => newEventScreenViewModel
                      .setDescription(newEventDescription),
                  validator: (value) =>
                      newEventScreenViewModel.validateDescription(value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderImagePicker(
                  name: 'photos',
                  decoration: InputDecoration(labelText: choosePicture),
                  maxImages: 1,
                  onChanged: (images) {
                    setState(() {
                      _imageFile = File(images![0].path);
                    });
                    newEventScreenViewModel.setImage(images![0].path);
                  },
                  validator: (value) => newEventScreenViewModel.validateImage(value),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: MyButton(create, () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      await newEventScreenViewModel.addNewEvent(
                          userModel.id, _imageFile!);
                      if (newEventScreenViewModel.errorMessages.isEmpty) {
                        Fluttertoast.showToast(msg: successfulAddMessage);
                        _formKey.currentState?.reset();
                        dateController.clear();
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text(
                                    errorDialogTitle,
                                    style: Styles.errorText,
                                  ),
                                  content: Text(
                                    newEventScreenViewModel.errorMessages
                                        .join(" "),
                                    style: Styles.errorText,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(close),
                                    )
                                  ],
                                ));
                      }
                    }
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
