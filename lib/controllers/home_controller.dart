import 'package:get/get.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';
import 'package:hris_rs_hamori/services/api_service.dart';

class HomeController extends GetxController {
  var employeeData = <String, String>{}.obs;
  var attendanceList = <Attendance>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var employee = await ApiService.getEmployeeInfo();
      var attendance = await ApiService.getAttendanceList();

      employeeData.value = employee;
      attendanceList.value = attendance;
    } catch (e) {
      errorMessage.value = "Gagal mengambil data.";
    } finally {
      isLoading.value = false;
    }
  }
}
