import 'package:firulapp/src/pets/components/adoptions/pet_for_adoption.dart';
import 'package:flutter/widgets.dart';

import './src/sign_up/components/sign_up_details_form.dart';
import './src/sign_in/sign_in_screen.dart';
import './src/home/home.dart';
import './src/profile/profile_screen.dart';
import './src/profile_detail/profile_details.dart';
import './src/pets/pets_screen.dart';
import './src/pets/selected_pet_screen.dart';
import './src/sign_up/sign_up_screen.dart';
import './src/pets/components/add_pets.dart';
import './src/medical_records/medical_records_screen.dart';
import './src/agenda/agenda_screen.dart';
import './src/medical_records/medical_record_form_screen.dart';
import './src/vaccionation_records/vaccination_records_form_screen.dart';
import './src/vaccionation_records/vaccination_records_screen.dart';
import './src/agenda/activity_form_screen.dart';
import './src/pets/lost_and_found/lost_and_found_map.dart';
import './src/pets/lost_and_found/found_pet/found_pet_form_step1.dart';
import './src/pets/lost_and_found/found_pet/found_pet_form_step2.dart';
import './src/pets/lost_and_found/lost_pet/lost_pet_form.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    HomeScreen.routeName: (context) => HomeScreen(),
    SignInScreen.routeName: (context) => SignInScreen(),
    ProfileScreen.routeName: (context) => ProfileScreen(),
    ProfilePage.routeName: (context) => ProfilePage(),
    PetsScreen.routeName: (context) => PetsScreen(),
    SelectedPetScreen.routeName: (context) => SelectedPetScreen(),
    SignUpScreen.routeName: (context) => SignUpScreen(),
    SignUpDetailsForm.routeName: (context) => SignUpDetailsForm(),
    AddPets.routeName: (context) => AddPets(),
    MedicalRecordsScreen.routeName: (context) => MedicalRecordsScreen(),
    NewMedicalRecordScreen.routeName: (context) => NewMedicalRecordScreen(),
    VaccinationRecordsScreen.routeName: (context) => VaccinationRecordsScreen(),
    NewVaccinationRecordScreen.routeName: (context) =>
        NewVaccinationRecordScreen(),
    AgendaScreen.routeName: (context) => AgendaScreen(),
    ActivityFormScreen.routeName: (context) => ActivityFormScreen(),
    LostAndFoundMap.routeName: (context) => LostAndFoundMap(),
    LostPetForm.routeName: (context) => LostPetForm(),
    PetForAdoption.routeName: (context) => PetForAdoption(),
    FoundPetFormStep1.routeName: (context) => FoundPetFormStep1(),
    FoundPetFormStep2.routeName: (context) => FoundPetFormStep2(),
  };
}
