const User=require('../models/userModel');const {success}=require('../utils/response');
exports.getProfile=async(req,res)=>success(res,await User.findById(req.user.id));
exports.updateProfile=async(req,res)=>success(res,await User.update(req.user.id,req.body),'Profile updated');
