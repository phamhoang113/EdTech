/**
 * Xác định trạng thái hiển thị của session trên UI.
 * Nếu session có status SCHEDULED/LIVE nhưng endTime đã qua → hiển thị COMPLETED.
 * Backend scheduler sẽ cập nhật DB vào 00:30 mỗi ngày, nhưng FE cần hiển thị đúng ngay lập tức.
 */
export function getDisplayStatus(
  status: string,
  sessionDate: string,
  endTime: string
): string {
  if (status !== 'SCHEDULED' && status !== 'LIVE') {
    return status;
  }

  const sessionEndDateTime = new Date(`${sessionDate}T${endTime}`);
  const now = new Date();

  if (sessionEndDateTime < now) {
    return 'COMPLETED';
  }

  return status;
}

/**
 * Kiểm tra session đã kết thúc hay chưa (dựa trên endTime).
 */
export function isSessionPast(sessionDate: string, endTime: string): boolean {
  const sessionEndDateTime = new Date(`${sessionDate}T${endTime}`);
  return sessionEndDateTime < new Date();
}
