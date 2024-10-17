

class SubString {
  static String truncateString(String str, int maxLength) {
  if (str.length <= maxLength) {
    return str; // ถ้ายาวน้อยกว่าหรือเท่ากับ maxLength ให้คืนค่าเดิม
  }
  return str.substring(0, maxLength) + '...'; // ตัดสตริงและเพิ่ม "..."
}

}