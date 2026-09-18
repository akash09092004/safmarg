const service=require('../services/refundService');const Refund=require('../models/refundModel');const {success}=require('../utils/response');
exports.request=async(req,res)=>success(res,await service.request(req.user,req.body),'Refund requested',201);
exports.mine=async(req,res)=>success(res,await Refund.findByUser(req.user.id));
