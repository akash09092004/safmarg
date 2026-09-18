const service=require('../services/paymentService');const {success}=require('../utils/response');
exports.pay=async(req,res)=>success(res,await service.pay(req.user,req.body),'Payment successful',201);
exports.byBooking=async(req,res)=>success(res,await service.byBooking(req.params.bookingId,req.user));
