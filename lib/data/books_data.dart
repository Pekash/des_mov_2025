class Book {
  final String title;
  final String author;
  final String image;
  final int? apiId;

  Book(this.title, this.author, this.image, {this.apiId});
}

List<Book> books = [
  Book('A Game of Thrones', 'George R.R. Martin', 'assets/images/agameofthrones.jpg', apiId: 1),
  Book('A Clash of Kings', 'George R.R. Martin', 'assets/images/aclashofkings.jpg', apiId: 2),
  Book('A Storm of Swords', 'George R.R. Martin', 'assets/images/astormofswords.jpg', apiId: 3),
  Book('A Feast for Crows', 'George R.R. Martin', 'assets/images/afeastforcrows.jpg', apiId: 5),
  Book('A Dance with Dragons', 'George R.R. Martin', 'assets/images/adancewithdragons.jpg', apiId: 8),
  Book('The Colour Out of Space', 'H.P. Lovecraft', 'assets/images/colouroutofspace.jpg'),
  Book('Dagon', 'H.P. Lovecraft', 'assets/images/dagon.jpg'),
  Book('The Call of Cthulhu', 'H.P. Lovecraft', 'assets/images/callofcthulhu.jpg'),
  Book('The Shadow Over Innsmouth', 'H.P. Lovecraft', 'assets/images/shadowsoverinnsmouth.jpg'),
  Book('The Final Empire', 'Brandon Sanderson', 'assets/images/thefinalempire.jpg'),
  Book('Mistborn', 'Brandon Sanderson', 'assets/images/mistborn.jpg'),
  Book('The Way of Kings', 'Brandon Sanderson', 'assets/images/thewayofthekings.jpg'),
  Book('Tress of the Emerald Sea', 'Brandon Sanderson', 'assets/images/treesoftheemeraldsea.jpg'),
  Book('The Wise Man\'s Fear', 'Patrick Rothfuss', 'assets/images/wisemansfear.jpg'),
  Book('The Name of the Wind', 'Patrick Rothfuss', 'assets/images/nameofthewind.jpg'),
];

List<String> authorNames = [
  'George R.R. Martin',
  'H.P. Lovecraft',
  'Brandon Sanderson',
  'Patrick Rothfuss',
];

List<String> authorImages = [
  'assets/images/georgerrmartin.jpg',
  'assets/images/hplovecraft.jpg',
  'assets/images/brandonsanderson.jpg',
  'assets/images/patrickrothfuss.jpg',
];