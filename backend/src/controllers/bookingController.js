const service=require('../services/bookingService');const Booking=require('../models/bookingModel');const {success}=require('../utils/response');
exports.create=async(req,res)=>success(res,await service.create(req.user,req.body),'Booking created',201);
exports.mine=async(req,res)=>success(res,await Booking.findByUser(req.user.id));
exports.details=async(req,res)=>success(res,await service.details(req.params.id,req.user));
exports.cancel=async(req,res)=>success(res,await service.cancel(req.params.id,req.user),'Booking cancelled');
exports.pnr=async(req,res)=>{const b=await Booking.findByPnr(req.params.pnr);if(!b||(req.user.role!=='admin'&&Number(b.user_id)!==Number(req.user.id))){const e=new Error('Booking not found');e.statusCode=404;throw e}success(res,b)};
