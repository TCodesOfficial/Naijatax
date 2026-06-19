import { DecodedUser } from '../auth/auth.middleware.js';

declare global {
  namespace Express {
    interface Request {
      user?: DecodedUser;
    }
  }
}
