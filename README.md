## 1. **Patient Management Systems**

These systems help organize patient records, track treatment plans, schedule appointments, and communicate with patients. They improve data accuracy and make healthcare more efficient.

---

## user management
### Admin-Only Routes

- /api/auth/register - create staff accounts
- /api/users/:id/role - change user roles
- /api/users/:id/activate - activate/deactivate user account

### other-user Routes
- /api/auth/login - authenticate
- /api/auth/change_password - change password obviously
- /api/auth/profile - view/ update profile
