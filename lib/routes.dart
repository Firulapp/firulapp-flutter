import 'package:flutter/widgets.dart';

import './src/sign_up/components/sign_up_details_form.dart';
import './src/sign_in/sign_in_screen.dart';
import './src/home/home.dart';
import './src/profile/profile_screen.dart';
import './src/profile_detail/profile_details.dart';
import './src/pets/pets_screen.dart';
import './src/sign_up/sign_up_screen.dart';
import './src/pets/components/add_pets.dart';
import './src/medial_records/medical_records_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ProfilePage.routeName: (context) => ProfilePage(),
  PetsScreen.routeName: (context) => PetsScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignUpDetailsForm.routeName: (context) => SignUpDetailsForm(),
  AddPets.routeName: (context) => AddPets(),
  MedicalRecordsScreen.routeName: (context) => MedicalRecordsScreen(),
};
