import 'package:get/get.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';
import 'package:hris_rs_hamori/services/api_service.dart';

class HomeController extends GetxController {
  var employeeData = {}.obs;
  var attendanceList = <Attendance>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading.value = true;
    try {
      var employee = await ApiService.getEmployeeInfo();
      var attendance = await ApiService.getAttendanceList();

      employeeData.value = employee;
      attendanceList.value = attendance;
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
