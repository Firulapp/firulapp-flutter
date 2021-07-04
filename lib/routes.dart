import 'package:flutter/widgets.dart';

import './src/sign_in/sign_in_screen.dart';
import './src/home/home.dart';
import './src/profile/profile_screen.dart';
import './src/profile_detail/profile_details.dart';
import './src/pets/pets_screen.dart';
import './src/pets/selected_pet_screen.dart';
import './src/sign_up/user/components/sign_up_details_form.dart';
import './src/sign_up/user/sign_up_screen.dart';
import './src/pets/components/add_pets.dart';
import './src/pets/medical_records/medical_records_screen.dart';
import './src/agenda/agenda_screen.dart';
import './src/pets/medical_records/medical_record_form_screen.dart';
import './src/pets/vaccionation_records/vaccination_records_form_screen.dart';
import './src/pets/vaccionation_records/vaccination_records_screen.dart';
import './src/pets/activity/activity_form_screen.dart';
import './src/pets/lost_and_found/lost_and_found_map.dart';
import './src/pets/lost_and_found/found_pet/found_pet_form_step1.dart';
import './src/pets/lost_and_found/found_pet/found_pet_form_step2.dart';
import './src/pets/lost_and_found/lost_pet/lost_pet_form.dart';
import './src/pets/lost_and_found/lost_pet/show_report.dart';
import './src/pets/pets_dashboard.dart';
import './src/pets/pets_screen_adoptions.dart';
import './src/pets/components/adoptions/transfer_pet.dart';
import './src/pet_services/service_categories_screen.dart';
import './src/pet_services/selected_category_screen.dart';
import './src/pets/components/adoptions/pet_in_adoption.dart';
import './src/pet_services/own_services/pet_service_form.dart';
import './src/pet_services/own_services/own_services_screen.dart';
import './src/pet_services/service_screen.dart';
import './src/pet_services/book_appointment.dart';
import './src/pets/components/adoptions/pet_for_adoption.dart';
import './src/sign_up/organization/organization_sign_up_screen.dart';
import './src/profile_detail/profile_details_organization.dart';

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
    FoundPetFormStep1.routeName: (context) => FoundPetFormStep1(),
    FoundPetFormStep2.routeName: (context) => FoundPetFormStep2(),
    ShowReport.routeName: (context) => ShowReport(),
    PetForAdoption.routeName: (context) => PetForAdoption(),
    PetsDashboard.routeName: (context) => PetsDashboard(),
    PetOnAdoption.routeName: (context) => PetOnAdoption(),
    TransferPet.routeName: (context) => TransferPet(),
    ServiceCategoriesScreen.routeName: (context) => ServiceCategoriesScreen(),
    SelectedCategoryScreen.routeName: (context) => SelectedCategoryScreen(),
    PetInAdoption.routeName: (context) => PetInAdoption(),
    PetServiceForm.routeName: (context) => PetServiceForm(),
    OrganizationSignUpScreen.routeName: (context) => OrganizationSignUpScreen(),
    ProfilePageOrganization.routeName: (context) => ProfilePageOrganization(),
    OwnServicesScreen.routeName: (context) => OwnServicesScreen(),
    ServiceScreen.routeName: (context) => ServiceScreen(),
    BookAppointment.routeName: (context) => BookAppointment(),
  };
}
