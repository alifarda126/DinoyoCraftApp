import 'package:flutter/material.dart';
class DetailProduk extends StatefulWidget {
	const DetailProduk({super.key});
	@override
	DetailProdukState createState() => DetailProdukState();
}
class DetailProdukState extends State<DetailProduk> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(25),
											color: Color(0xFFFFFFFF),
										),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											padding: const EdgeInsets.only( top: 8),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 4, left: 7, right: 7),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( top: 1, left: 35, right: 35),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"9:41",
																							style: TextStyle(
																								color: Color(0xFF000000),
																								fontSize: 17,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Container(
																		width: 108,
																		height: 22,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hr864gt0_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 17),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.only(
																					topLeft: Radius.circular(25),
																					topRight: Radius.circular(25),
																				),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Container(
																						width: 21,
																						height: 25,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vympxm9c_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Column(
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														margin: const EdgeInsets.only( left: 38),
																														width: 40,
																														height: 40,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vpgc704q_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Container(
																														width: 40,
																														height: 40,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/n4gja7of_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( top: 361, right: 16),
																			width: double.infinity,
																			decoration: BoxDecoration(
																				image: DecorationImage(
																					image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ccoa44jg_expires_30_days.png"),
																					fit: BoxFit.fill
																				),
																			),
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.end,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(9999),
																									color: Color(0xFFFFFFFF),
																									boxShadow: [
																										BoxShadow(
																											color: Color(0x0D000000),
																											blurRadius: 2,
																											offset: Offset(0, 1),
																										),
																									],
																								),
																								padding: const EdgeInsets.only( top: 2, bottom: 2, left: 10, right: 10),
																								margin: const EdgeInsets.only( bottom: 17),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"1 / 4",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 11,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 16, left: 18, right: 18),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 34),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( top: 2),
																											margin: const EdgeInsets.only( bottom: 12),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Text(
																														"Cangkir Handmade",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 24,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( top: 14, bottom: 3),
																											margin: const EdgeInsets.only( bottom: 12),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 13),
																														child: Text(
																															"Rp65.000",
																															style: TextStyle(
																																color: Color(0xFF000000),
																																fontSize: 26,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													),
																													Text(
																														"Rp110.000",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 14,
																															decoration: TextDecoration.lineThrough,
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.symmetric(vertical: 4),
																											width: double.infinity,
																											child: Row(
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 8),
																																child: Row(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( right: 4),
																																			width: 14,
																																			height: 13,
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ksoiqk91_expires_30_days.png",
																																				fit: BoxFit.fill,
																																			)
																																		),
																																		Text(
																																			"4.9",
																																			style: TextStyle(
																																				color: Color(0xFF000000),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Container(
																														margin: const EdgeInsets.only( right: 8),
																														child: Text(
																															"•",
																															style: TextStyle(
																																color: Color(0xFFCFC4C5),
																																fontSize: 12,
																															),
																														),
																													),
																													Container(
																														margin: const EdgeInsets.only( right: 8),
																														child: Text(
																															"128 Ulasan",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 14,
																																decoration: TextDecoration.underline,
																															),
																														),
																													),
																													Container(
																														margin: const EdgeInsets.only( right: 8),
																														child: Text(
																															"•",
																															style: TextStyle(
																																color: Color(0xFFCFC4C5),
																																fontSize: 12,
																															),
																														),
																													),
																													Text(
																														"Terjual 340+",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 14,
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFF000000),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																								boxShadow: [
																									BoxShadow(
																										color: Color(0x0D000000),
																										blurRadius: 2,
																										offset: Offset(0, 1),
																									),
																								],
																							),
																							padding: const EdgeInsets.all(17),
																							margin: const EdgeInsets.only( bottom: 15),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 11),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( right: 12),
																															width: 48,
																															height: 48,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/q1naplrz_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Expanded(
																															child: IntrinsicHeight(
																																child: Container(
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( bottom: 1),
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Karya Tanah ",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 16,
																																									fontWeight: FontWeight.bold,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																			IntrinsicWidth(
																																				child: IntrinsicHeight(
																																					child: Container(
																																						width: double.infinity,
																																						child: Row(
																																							children: [
																																								Container(
																																									margin: const EdgeInsets.only( right: 9),
																																									width: 9,
																																									height: 11,
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/uhz70hir_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								),
																																								Text(
																																									"Kampung Keramik D...",
																																									style: TextStyle(
																																										color: Color(0xFF000000),
																																										fontSize: 12,
																																									),
																																								),
																																							]
																																						),
																																					),
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									InkWell(
																										onTap: () { print('Pressed'); },
																										child: IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xFF000000),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(9999),
																													),
																													padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Kunjungi Toko",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 11,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 16),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( bottom: 8),
																															width: double.infinity,
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Text(
																																		"Deskripsi Produk",
																																		style: TextStyle(
																																			color: Color(0xFF1A1C1C),
																																			fontSize: 18,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																]
																															),
																														),
																													),
																													IntrinsicHeight(
																														child: Container(
																															width: double.infinity,
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Container(
																																		width: double.infinity,
																																		child: Text(
																																			"Vas keramik stoneware buatan tangan pengrajin lokal\nDinoyo. Dibakar pada suhu tinggi 1.250°C\nmenghasilkan material yang padat, tahan air, dan\nawet. Tekstur matte halus dengan sentuhan hangat\nalami, cocok untuk dekorasi meja, bunga kering,\nmaupun interior minimalis.",
																																			style: TextStyle(
																																				color: Color(0xFF4C4546),
																																				fontSize: 14,
																																			),
																																		),
																																	),
																																]
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFF000000),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(17),
																											margin: const EdgeInsets.only( bottom: 16),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( bottom: 13),
																															width: double.infinity,
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Text(
																																		"Spesifikasi Detail",
																																		style: TextStyle(
																																			color: Color(0xFF1A1C1C),
																																			fontSize: 16,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																]
																															),
																														),
																													),
																													IntrinsicHeight(
																														child: Container(
																															width: double.infinity,
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	IntrinsicHeight(
																																		child: Container(
																																			margin: const EdgeInsets.only( bottom: 14),
																																			width: double.infinity,
																																			child: Row(
																																				children: [
																																					Expanded(
																																						child: IntrinsicHeight(
																																							child: Container(
																																								margin: const EdgeInsets.only( right: 16),
																																								width: double.infinity,
																																								child: Column(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										IntrinsicHeight(
																																											child: Container(
																																												margin: const EdgeInsets.only( bottom: 2),
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Bahan Utama",
																																															style: TextStyle(
																																																color: Color(0xFF5F5E5E),
																																																fontSize: 12,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																										IntrinsicHeight(
																																											child: Container(
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Container(
																																															width: double.infinity,
																																															child: Text(
																																																"Tanah Liat Dinoyo\n(Stoneware)",
																																																style: TextStyle(
																																																	color: Color(0xFF1A1C1C),
																																																	fontSize: 14,
																																																),
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																					),
																																					Expanded(
																																						child: IntrinsicHeight(
																																							child: Container(
																																								padding: const EdgeInsets.only( bottom: 18),
																																								width: double.infinity,
																																								child: Column(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										IntrinsicHeight(
																																											child: Container(
																																												margin: const EdgeInsets.only( bottom: 2),
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Finishing",
																																															style: TextStyle(
																																																color: Color(0xFF5F5E5E),
																																																fontSize: 12,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																										IntrinsicHeight(
																																											child: Container(
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Matte Glaze Alami",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																					),
																																				]
																																			),
																																		),
																																	),
																																	IntrinsicHeight(
																																		child: Container(
																																			width: double.infinity,
																																			child: Row(
																																				children: [
																																					Expanded(
																																						child: IntrinsicHeight(
																																							child: Container(
																																								margin: const EdgeInsets.only( right: 16),
																																								width: double.infinity,
																																								child: Column(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										IntrinsicHeight(
																																											child: Container(
																																												margin: const EdgeInsets.only( bottom: 2),
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Dimensi Produk",
																																															style: TextStyle(
																																																color: Color(0xFF5F5E5E),
																																																fontSize: 12,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																										IntrinsicHeight(
																																											child: Container(
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"T 18cm × D 9cm",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																					),
																																					Expanded(
																																						child: IntrinsicHeight(
																																							child: Container(
																																								width: double.infinity,
																																								child: Column(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										IntrinsicHeight(
																																											child: Container(
																																												margin: const EdgeInsets.only( bottom: 2),
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Berat Bersih",
																																															style: TextStyle(
																																																color: Color(0xFF5F5E5E),
																																																fontSize: 12,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																										IntrinsicHeight(
																																											child: Container(
																																												width: double.infinity,
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"600 gram",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																					),
																																				]
																																			),
																																		),
																																	),
																																]
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFFCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFEEEEEE),
																											),
																											padding: const EdgeInsets.all(15),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 10),
																														width: 18,
																														height: 15,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/c6iit5pa_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( bottom: 3),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Garansi Kemasan Aman Dinoyo",
																																							style: TextStyle(
																																								color: Color(0xFF1A1C1C),
																																								fontSize: 12,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																					]
																																				),
																																			),
																																		),
																																		IntrinsicHeight(
																																			child: Container(
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							width: 282,
																																							child: Text(
																																								"Setiap keramik dibalut triple bubble wrap & kotak\nkardus kayu tebal untuk memastikan produk\nsampai utuh.",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						),
																																					]
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(17),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 16),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															margin: const EdgeInsets.only( left: 16),
																															child: Text(
																																"4.9",
																																style: TextStyle(
																																	color: Color(0xFF1A1C1C),
																																	fontSize: 36,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	margin: const EdgeInsets.only( right: 17),
																																	child: Column(
																																		children: [
																																			Container(
																																				width: 91,
																																				height: 23,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/taohep1v_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																			IntrinsicWidth(
																																				child: IntrinsicHeight(
																																					child: Container(
																																						padding: const EdgeInsets.only( top: 4),
																																						child: Column(
																																							children: [
																																								Text(
																																									"128 ulasan",
																																									style: TextStyle(
																																										color: Color(0xFF5F5E5E),
																																										fontSize: 12,
																																									),
																																								),
																																							]
																																						),
																																					),
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 6),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 4, right: 4),
																																					margin: const EdgeInsets.only( right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"5",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Expanded(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(9999),
																																						color: Color(0xFFEEEEEE),
																																					),
																																					margin: const EdgeInsets.only( right: 9),
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(9999),
																																									color: Color(0xFF000000),
																																								),
																																								width: 130,
																																								height: 8,
																																								child: SizedBox(),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 3, right: 3),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"92%",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 11,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 6),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 4, right: 4),
																																					margin: const EdgeInsets.only( right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"4",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Expanded(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(9999),
																																						color: Color(0xFFEEEEEE),
																																					),
																																					margin: const EdgeInsets.only( right: 9),
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(9999),
																																									color: Color(0xFF000000),
																																								),
																																								width: 8,
																																								height: 8,
																																								child: SizedBox(),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 10, right: 10),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"6%",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 11,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 6),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 4, right: 4),
																																					margin: const EdgeInsets.only( right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"3",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Expanded(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																					color: Color(0xFFEEEEEE),
																																				),
																																				margin: const EdgeInsets.only( right: 9),
																																				height: 8,
																																				width: double.infinity,
																																				child: SizedBox(),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 10, right: 10),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"2%",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 11,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 6),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 5, right: 5),
																																					margin: const EdgeInsets.only( right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"2",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Expanded(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																					color: Color(0xFFEEEEEE),
																																				),
																																				margin: const EdgeInsets.only( right: 9),
																																				height: 8,
																																				width: double.infinity,
																																				child: SizedBox(),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 8, right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"0%",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 11,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 7, right: 7),
																																					margin: const EdgeInsets.only( right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"1",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Expanded(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(9999),
																																					color: Color(0xFFEEEEEE),
																																				),
																																				margin: const EdgeInsets.only( right: 9),
																																				height: 8,
																																				width: double.infinity,
																																				child: SizedBox(),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( left: 8, right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"0%",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 11,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFF4F3F3),
																							),
																							padding: const EdgeInsets.symmetric(vertical: 13),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																										),
																										margin: const EdgeInsets.only( left: 12, right: 8),
																										width: 15,
																										height: 15,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(12),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9oo1l2n3_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( right: 27),
																												margin: const EdgeInsets.only( right: 1),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: double.infinity,
																															child: Text(
																																"98% pembeli merekomendasikan produk ini",
																																style: TextStyle(
																																	color: Color(0xFF1A1C1C),
																																	fontSize: 12,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 9, left: 1, right: 1),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.only( top: 17, bottom: 17, right: 17),
																			margin: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8, left: 17),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Row(
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(9999),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 40,
																														height: 40,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(9999),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/w6ink72m_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( bottom: 2),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( bottom: 5),
																																			child: Text(
																																				"Mochammad Al Mizan",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 14,
																																				),
																																			),
																																		),
																																		Container(
																																			margin: const EdgeInsets.only( right: 76),
																																			child: Text(
																																				"12 Feb 2025",
																																				style: TextStyle(
																																					color: Color(0xFF5F5E5E),
																																					fontSize: 12,
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																									Container(
																										width: 2,
																										height: 12,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/sajf7vpu_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 2),
																							margin: const EdgeInsets.only( bottom: 8, left: 17),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										margin: const EdgeInsets.only( bottom: 4),
																										height: 11,
																										width: double.infinity,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/jhrrcipk_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( right: 34),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: double.infinity,
																														child: Text(
																															"Varian: Sand White Glossy - Vas Keramik Minimalis",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 12,
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8, left: 17),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Glasirnya sangat halus dan rapi, warna aslinya",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Text(
																										"lebih estetik daripada di foto. Pengemasan kayu",
																										style: TextStyle(
																											color: Color(0xFF1A1C1C),
																											fontSize: 14,
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"sangat kokoh dan aman sampai rumah tanpa",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"retak sedikitpun. Sangat bangga dengan karya",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Text(
																										"pengrajin Dinoyo Malang!",
																										style: TextStyle(
																											color: Color(0xFF1A1C1C),
																											fontSize: 14,
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.symmetric(vertical: 9),
																							margin: const EdgeInsets.only( bottom: 8, left: 17),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCFC4C5),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(9999),
																												),
																												padding: const EdgeInsets.only( top: 5, bottom: 5, left: 13, right: 13),
																												margin: const EdgeInsets.only( right: 32),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(9999),
																															),
																															margin: const EdgeInsets.only( right: 6),
																															width: 12,
																															height: 11,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(9999),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9v94k2gl_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Expanded(
																															child: IntrinsicHeight(
																																child: Container(
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"Membantu (14)",
																																				style: TextStyle(
																																					color: Color(0xFF4C4546),
																																					fontSize: 12,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Apakah ulasan ini bermanfaat?",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 11,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(10),
																						),
																						margin: const EdgeInsets.only( bottom: 7, left: 17),
																						width: 142,
																						height: 142,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(10),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ie3bs9gl_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFF4F3F3),
																							),
																							padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																							margin: const EdgeInsets.only( left: 17),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 4),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 6),
																														width: 10,
																														height: 9,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zciamyi2_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Container(
																														margin: const EdgeInsets.only( right: 6),
																														child: Text(
																															"Karya Tanah",
																															style: TextStyle(
																																color: Color(0xFF1A1C1C),
																																fontSize: 12,
																																fontWeight: FontWeight.bold,
																															),
																														),
																													),
																													Text(
																														"• 13 Feb 2025",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 12,
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: double.infinity,
																														child: Text(
																															"\"Terima kasih banyak Mas Mizan atas apresiasinya!\nSemoga vas keramiknya mempercantik ruangan\nrumah.\"",
																															style: TextStyle(
																																color: Color(0xFF4C4546),
																																fontSize: 12,
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(17),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Row(
																												children: [
																													InkWell(
																														onTap: () { print('Pressed'); },
																														child: IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFFEEEEEE),
																																	),
																																	padding: const EdgeInsets.all(11),
																																	margin: const EdgeInsets.only( right: 12),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"RH",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 12,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( bottom: 2),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( bottom: 5),
																																			child: Text(
																																				"Rian Hidayat",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 14,
																																				),
																																			),
																																		),
																																		Container(
																																			margin: const EdgeInsets.only( right: 19),
																																			child: Text(
																																				"8 Feb 2025",
																																				style: TextStyle(
																																					color: Color(0xFF5F5E5E),
																																					fontSize: 12,
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																									Container(
																										width: 2,
																										height: 12,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/uyn7ak3l_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 2),
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										margin: const EdgeInsets.only( bottom: 3),
																										height: 11,
																										width: double.infinity,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9s54g3fs_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( right: 35),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: double.infinity,
																														child: Text(
																															"Varian: Earth Terracotta - Mangkuk Saji Wabi-Sabi",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 12,
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Barang sampai dengan selamat di Surabaya.",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Packing bubble wrap tebal lapis tiga. Bentuk",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"mangkuknya unik bergaya wabi-sabi natural.",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Text(
																										"Pasti bakal order lagi buat koleksi dapur.",
																										style: TextStyle(
																											color: Color(0xFF1A1C1C),
																											fontSize: 14,
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.symmetric(vertical: 9),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									InkWell(
																										onTap: () { print('Pressed'); },
																										child: IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xFFCFC4C5),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(9999),
																													),
																													padding: const EdgeInsets.only( top: 5, bottom: 5, left: 13, right: 13),
																													child: Row(
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(9999),
																																),
																																margin: const EdgeInsets.only( right: 6),
																																width: 12,
																																height: 11,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(9999),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/naubirvy_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Text(
																																"Membantu (5)",
																																style: TextStyle(
																																	color: Color(0xFF4C4546),
																																	fontSize: 12,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																									),
																									Text(
																										"Membantu 5 orang",
																										style: TextStyle(
																											color: Color(0xFF5F5E5E),
																											fontSize: 11,
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xF0FFFFFF),
															padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(92),
																		),
																		margin: const EdgeInsets.only( right: 10),
																		width: 44,
																		height: 44,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(92),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/onbkunjv_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Row(
																					children: [
																						Expanded(
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0xFF000000),
																											width: 2,
																										),
																										borderRadius: BorderRadius.circular(61),
																										color: Color(0xFFFFFFFF),
																									),
																									padding: const EdgeInsets.symmetric(vertical: 16),
																									margin: const EdgeInsets.only( right: 10),
																									width: double.infinity,
																									child: Row(
																										mainAxisAlignment: MainAxisAlignment.center,
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														margin: const EdgeInsets.only( right: 7),
																														child: Stack(
																															clipBehavior: Clip.none,
																															children: [
																																Padding(
																																	padding: const EdgeInsets.only( top: 1, bottom: 1, left: 2, right: 2),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Container(
																																				width: 12,
																																				height: 11,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/r31t8tq4_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																		]
																																	),
																																),
																																Positioned(
																																	top: 1,
																																	left: 7,
																																	right: 7,
																																	height: 10,
																																	child: Container(
																																		width: double.infinity,
																																		child: Text(
																																			"+",
																																			style: TextStyle(
																																				color: Color(0xFF000000),
																																				fontSize: 7,
																																				fontWeight: FontWeight.bold,
																																			),
																																			textAlign: TextAlign.center,
																																		),
																																	),
																																),
																															]
																														),
																													),
																												),
																											),
																											Text(
																												"Keranjang",
																												style: TextStyle(
																													color: Color(0xFF000000),
																													fontSize: 12,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						Expanded(
																							child: InkWell(
																								onTap: () { print('Pressed'); },
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(16),
																											color: Color(0x00FFFFFF),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x1A000000),
																													blurRadius: 4,
																													offset: Offset(0, 2),
																												),
																											],
																										),
																										padding: const EdgeInsets.symmetric(vertical: 16),
																										width: double.infinity,
																										child: Column(
																											children: [
																												Text(
																													"Beli Langsung",
																													style: TextStyle(
																														color: Color(0xFFFFFFFF),
																														fontSize: 12,
																														fontWeight: FontWeight.bold,
																													),
																												),
																											]
																										),
																									),
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}