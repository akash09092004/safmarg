const Seat=require('../models/seatModel');const {success}=require('../utils/response');
exports.byFlight=async(req,res)=>success(res,await Seat.findByFlight(req.params.flightId));
