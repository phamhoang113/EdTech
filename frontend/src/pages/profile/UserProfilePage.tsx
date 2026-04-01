import { useAuthStore } from '../../store/useAuthStore';
import TutorProfilePage from './TutorProfilePage';
import { ParentProfileForm } from './ParentProfileForm';
import { StudentProfileForm } from './StudentProfileForm';

/**
 * Wrapper component: tự detect role → render form profile tương ứng.
 * - TUTOR: giữ nguyên TutorProfilePage (đầy đủ fields chuyên biệt)
 * - PARENT: ParentProfileForm (avatar, email, địa chỉ)
 * - STUDENT: StudentProfileForm (avatar, email, trường, lớp)
 */
export default function UserProfilePage() {
  const { user } = useAuthStore();
  const role = user?.role;

  if (role === 'TUTOR') return <TutorProfilePage />;
  if (role === 'PARENT') return <ParentProfileForm />;
  if (role === 'STUDENT') return <StudentProfileForm />;

  return (
    <div style={{ padding: 40, textAlign: 'center', color: '#6b7280' }}>
      Không xác định được vai trò người dùng.
    </div>
  );
}
