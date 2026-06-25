import { DecodedUser } from '../auth/auth.middleware.js';
import { Multer } from 'multer';

declare global {
  namespace Express {
    interface Request {
      user?: DecodedUser;
      file?: Express.Multer.File;
    }
  }
}
