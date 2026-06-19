import { Router } from 'express';
import multer from 'multer';
import { calculateTax, parseStatement, searchVat } from '../controllers/tax.controller.js';
import { optionalAuth, requireAuth } from '../auth/auth.middleware.js';

const router = Router();
// Store upload in memory (no disk writes)
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

// Guest-accessible: Calculate tax (saves to DB only if logged in)
router.post('/calculate', optionalAuth, calculateTax);

// Guest-accessible: Search VAT items
router.get('/vat', optionalAuth, searchVat);

// Auth-required: Upload & parse bank statement PDF
router.post('/parse-statement', requireAuth, upload.single('statement'), parseStatement);

export default router;
