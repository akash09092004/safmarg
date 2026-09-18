const service=require('../services/authService');const {success}=require('../utils/response');
exports.register=async(req,res)=>success(res,await service.register(req.body),'Registration successful',201);
exports.login=async(req,res)=>success(res,await service.login(req.body.email,req.body.password),'Login successful');
exports.me=async(req,res)=>success(res,req.user);
