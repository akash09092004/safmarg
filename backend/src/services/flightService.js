const Flight=require('../models/flightModel'); const Seat=require('../models/seatModel');
exports.search=filters=>Flight.search(filters);
exports.details=async id=>{const flight=await Flight.findById(id);if(!flight){const e=new Error('Flight not found');e.statusCode=404;throw e} return {...flight,seats:await Seat.findByFlight(id)};};
