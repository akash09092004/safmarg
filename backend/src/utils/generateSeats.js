const SEAT_LETTERS = ['A', 'B', 'C', 'D', 'E', 'F'];

module.exports = function generateSeats(totalSeats) {
  const count = Number(totalSeats);
  if (!Number.isInteger(count) || count < 1 || count > 1000) {
    const error = new Error('total_seats must be an integer between 1 and 1000');
    error.statusCode = 422;
    throw error;
  }

  return Array.from({ length: count }, (_, index) => {
    const row = Math.floor(index / SEAT_LETTERS.length) + 1;
    const seatClass = row <= 2 ? 'business' : row <= 5 ? 'premium_economy' : 'economy';
    const priceModifier = seatClass === 'business' ? 2500 : seatClass === 'premium_economy' ? 1200 : 0;
    return {
      seatNumber: `${row}${SEAT_LETTERS[index % SEAT_LETTERS.length]}`,
      seatClass,
      priceModifier,
    };
  });
};
