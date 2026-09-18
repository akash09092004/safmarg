const service=require('../services/flightService');const {success}=require('../utils/response');
exports.search=async(req,res)=>success(res,await service.search(req.query));
exports.details=async(req,res)=>success(res,await service.details(req.params.id));
