import 'package:flutter/material.dart';
class ProfileToko extends StatefulWidget {
	const ProfileToko({super.key});
	@override
	ProfileTokoState createState() => ProfileTokoState();
}
class ProfileTokoState extends State<ProfileToko> {
	String textField1 = '';
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
															margin: const EdgeInsets.only( bottom: 26, left: 7, right: 7),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/96k3uhs9_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 8),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					width: double.infinity,
																					child: Stack(
																						clipBehavior: Clip.none,
																						children: [
																							Padding(
																								padding: const EdgeInsets.only( top: 152),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( left: 16, right: 16),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 14),
																																width: double.infinity,
																																child: Stack(
																																	clipBehavior: Clip.none,
																																	children: [
																																		Column(
																																			crossAxisAlignment: CrossAxisAlignment.start,
																																			children: [
																																				IntrinsicHeight(
																																					child: Container(
																																						width: double.infinity,
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								InkWell(
																																									onTap: () { print('Pressed'); },
																																									child: IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												decoration: BoxDecoration(
																																													border: Border.all(
																																														color: Color(0xFFFAF9F9),
																																														width: 2,
																																													),
																																													borderRadius: BorderRadius.circular(16),
																																													color: Color(0xFFFFFFFF),
																																													boxShadow: [
																																														BoxShadow(
																																															color: Color(0x1A000000),
																																															blurRadius: 4,
																																															offset: Offset(0, 2),
																																														),
																																													],
																																												),
																																												padding: const EdgeInsets.only( top: 2, bottom: 2, left: 3, right: 3),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Container(
																																															decoration: BoxDecoration(
																																																borderRadius: BorderRadius.circular(12),
																																															),
																																															width: 75,
																																															height: 75,
																																															child: ClipRRect(
																																																borderRadius: BorderRadius.circular(12),
																																																child: Image.network(
																																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/npqttlu0_expires_30_days.png",
																																																	fit: BoxFit.fill,
																																																)
																																															)
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
																																			]
																																		),
																																		Positioned(
																																			bottom: 0,
																																			right: 1,
																																			child: InkWell(
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
																																								color: Color(0xFFFFFFFF),
																																								boxShadow: [
																																									BoxShadow(
																																										color: Color(0x0D000000),
																																										blurRadius: 2,
																																										offset: Offset(0, 1),
																																									),
																																								],
																																							),
																																							padding: const EdgeInsets.only( top: 6, bottom: 6, left: 13, right: 13),
																																							transform: Matrix4.translationValues(0, 6, 0),
																																							child: Column(
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
																																														margin: const EdgeInsets.only( right: 6),
																																														width: 15,
																																														height: 14,
																																														child: ClipRRect(
																																															borderRadius: BorderRadius.circular(9999),
																																															child: Image.network(
																																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zwsfetj8_expires_30_days.png",
																																																fit: BoxFit.fill,
																																															)
																																														)
																																													),
																																													Container(
																																														margin: const EdgeInsets.only( right: 6),
																																														child: Text(
																																															"4.9",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																																fontWeight: FontWeight.bold,
																																															),
																																														),
																																													),
																																													Text(
																																														"(128 Ulasan)",
																																														style: TextStyle(
																																															color: Color(0xFF5F5E5E),
																																															fontSize: 12,
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
																																				margin: const EdgeInsets.only( bottom: 10),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Dinoyo Ceramic Studio",
																																							style: TextStyle(
																																								color: Color(0xFF1A1C1C),
																																								fontSize: 20,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																					]
																																				),
																																			),
																																		),
																																		IntrinsicHeight(
																																			child: Container(
																																				alignment: Alignment.center,
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xFFCFC4C5),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(12),
																																					color: Color(0xFFFFFFFF),
																																				),
																																				margin: const EdgeInsets.only( top: 2),
																																				width: double.infinity,
																																				child: TextField(
																																					style: TextStyle(
																																						color: Color(0xFF4C4546),
																																						fontSize: 14,
																																					),
																																					onChanged: (value) { 
																																						setState(() { textField1 = value; });
																																					},
																																					decoration: InputDecoration(
																																						hintText: "Studio keramik keluarga yang melestarikan senitembikar Dinoyo sejak 1985. Menyediakanperlengkapan makan stoneware, vas hias, hinggasuvenir keramik buatan tangan langsung daritungku pembakaran lokal.",
																																						isDense: true,
																																						contentPadding: const EdgeInsets.all(9),
																																						border: InputBorder.none,
																																						focusedBorder: InputBorder.none,
																																						filled: false,
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
																							Positioned(
																								top: 0,
																								left: 0,
																								right: 0,
																								height: 192,
																								child: Container(
																									decoration: BoxDecoration(
																										gradient: LinearGradient(
																											begin: Alignment(-1, -1),
																											end: Alignment(-1, 1),
																											colors: [
																												Color(0xCC000000),
																												Color(0x4D000000),
																												Color(0x00000000),
																											],
																										),
																									),
																									height: 192,
																									width: double.infinity,
																									child: SizedBox(),
																								),
																							),
																						]
																					),
																				),
																			),
																		]
																	),
																	Positioned(
																		top: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.only(
																						topLeft: Radius.circular(25),
																						topRight: Radius.circular(25),
																					),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 13, bottom: 13, left: 16, right: 16),
																				transform: Matrix4.translationValues(0, -22, 0),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(9999),
																															),
																															margin: const EdgeInsets.only( right: 8),
																															width: 21,
																															height: 25,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(9999),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/42t1k9iw_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Profil Toko",
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
																										Container(
																											width: 24,
																											height: 28,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lni0neo0_expires_30_days.png",
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
																	),
																]
															),
														),
													),
													InkWell(
														onTap: () { print('Pressed'); },
														child: IntrinsicHeight(
															child: Container(
																decoration: BoxDecoration(
																	borderRadius: BorderRadius.circular(12),
																	color: Color(0xFF000000),
																	boxShadow: [
																		BoxShadow(
																			color: Color(0x0D000000),
																			blurRadius: 2,
																			offset: Offset(0, 1),
																		),
																	],
																),
																padding: const EdgeInsets.symmetric(vertical: 10),
																margin: const EdgeInsets.only( bottom: 8, left: 18, right: 18),
																width: double.infinity,
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.center,
																	children: [
																		Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(12),
																			),
																			margin: const EdgeInsets.only( right: 7),
																			width: 15,
																			height: 15,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(12),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8e9xs3n4_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			)
																		),
																		Text(
																			"Chat Toko",
																			style: TextStyle(
																				color: Color(0xFFFFFFFF),
																				fontSize: 12,
																			),
																		),
																	]
																),
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
																color: Color(0xFFF4F3F3),
															),
															padding: const EdgeInsets.only( top: 11, bottom: 11, left: 14, right: 14),
															margin: const EdgeInsets.only( bottom: 13, left: 18, right: 18),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 9),
																		width: 13,
																		height: 13,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/sp1war8o_expires_30_days.png",
																			fit: BoxFit.fill,
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
																							"Cari produk di toko ini...",
																							style: TextStyle(
																								color: Color(0xFF5F5E5E),
																								fontSize: 14,
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
															margin: const EdgeInsets.only( bottom: 15, left: 5, right: 5),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 15),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							margin: const EdgeInsets.only( left: 13),
																							child: Text(
																								"Katalog",
																								style: TextStyle(
																									color: Color(0xFF1A1C1C),
																									fontSize: 16,
																									fontWeight: FontWeight.bold,
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(17),
																									color: Color(0xFFFFFFFF),
																								),
																								padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 7),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(17),
																															),
																															margin: const EdgeInsets.only( bottom: 8),
																															width: 157,
																															height: 170,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(17),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mmgbfa5b_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( right: 39),
																																			child: Text(
																																				"Vas Minimalis",
																																				style: TextStyle(
																																					color: Color(0xFF1A1A1A),
																																					fontSize: 13,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		),
																																		Text(
																																			"Dinoyo Ceramic Studio",
																																			style: TextStyle(
																																				color: Color(0xFF1A1A1A),
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
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 4),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Rp85.000",
																															style: TextStyle(
																																color: Color(0xFF1A1A1A),
																																fontSize: 13,
																																fontWeight: FontWeight.bold,
																															),
																														),
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(9400),
																															),
																															width: 30,
																															height: 30,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(9400),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x002yaav_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
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
																									crossAxisAlignment: CrossAxisAlignment.end,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 12),
																											child: Text(
																												"Menampilkan 8 Produk",
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
																						IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(17),
																									color: Color(0xFFFFFFFF),
																								),
																								padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 7),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 13, bottom: 141, left: 8, right: 8),
																																margin: const EdgeInsets.only( bottom: 8),
																																width: double.infinity,
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(17),
																																	image: DecorationImage(
																																		image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/j18df3is_expires_30_days.png"),
																																		fit: BoxFit.fill
																																	),
																																),
																																child: Row(
																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(8036),
																																						color: Color(0xD91A1A1A),
																																						boxShadow: [
																																							BoxShadow(
																																								color: Color(0x0D000000),
																																								blurRadius: 1,
																																								offset: Offset(0, 0.8037137389183044),
																																							),
																																						],
																																					),
																																					padding: const EdgeInsets.only( top: 2, bottom: 2, left: 6, right: 6),
																																					child: Row(
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(8036),
																																								),
																																								margin: const EdgeInsets.only( right: 3),
																																								width: 9,
																																								height: 9,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(8036),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/23x5l1ki_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Text(
																																								"Hot",
																																								style: TextStyle(
																																									color: Color(0xFFFFFFFF),
																																									fontSize: 8,
																																									fontWeight: FontWeight.bold,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(7425),
																																						color: Color(0xD9FFFFFF),
																																						boxShadow: [
																																							BoxShadow(
																																								color: Color(0x0D000000),
																																								blurRadius: 1,
																																								offset: Offset(0, 0.7426701784133911),
																																							),
																																						],
																																					),
																																					padding: const EdgeInsets.only( top: 1, bottom: 1, left: 6, right: 6),
																																					child: Row(
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(7425),
																																								),
																																								margin: const EdgeInsets.only( right: 2),
																																								width: 8,
																																								height: 8,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(7425),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/apspw1a5_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Text(
																																								"4.9",
																																								style: TextStyle(
																																									color: Color(0xFF000000),
																																									fontSize: 8,
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
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Cangkir Handmade",
																																			style: TextStyle(
																																				color: Color(0xFF1A1A1A),
																																				fontSize: 13,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																		Container(
																																			margin: const EdgeInsets.only( right: 60),
																																			child: Text(
																																				"Karya Tanah",
																																				style: TextStyle(
																																					color: Color(0xFF1A1A1A),
																																					fontSize: 11,
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
																												padding: const EdgeInsets.symmetric(vertical: 4),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Rp65.000",
																															style: TextStyle(
																																color: Color(0xFF1A1A1A),
																																fontSize: 13,
																																fontWeight: FontWeight.bold,
																															),
																														),
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(9400),
																															),
																															width: 30,
																															height: 30,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(9400),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/jt3wb997_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 16, left: 5, right: 5),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(17),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.all(13),
																				margin: const EdgeInsets.only( right: 15),
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
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( top: 14, right: 10),
																												margin: const EdgeInsets.only( bottom: 8),
																												width: double.infinity,
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(17),
																													image: DecorationImage(
																														image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/adhdy5fa_expires_30_days.png"),
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
																																		borderRadius: BorderRadius.circular(7425),
																																		color: Color(0xD9FFFFFF),
																																		boxShadow: [
																																			BoxShadow(
																																				color: Color(0x0D000000),
																																				blurRadius: 1,
																																				offset: Offset(0, 0.7426701784133911),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 6, right: 6),
																																	margin: const EdgeInsets.only( bottom: 140),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(7425),
																																				),
																																				margin: const EdgeInsets.only( right: 3),
																																				width: 8,
																																				height: 8,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(7425),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/o33ur6w7_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 8,
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
																										Text(
																											"Mangkuk Keramik",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Text(
																											"Ruang Tanah",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.symmetric(vertical: 3),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										Text(
																											"Rp75.000",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9400),
																											),
																											width: 30,
																											height: 30,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9400),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xtdaeq3c_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
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
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(17),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.all(13),
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
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( top: 14, right: 9),
																												margin: const EdgeInsets.only( bottom: 8),
																												width: double.infinity,
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(17),
																													image: DecorationImage(
																														image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qva0gvqs_expires_30_days.png"),
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
																																		borderRadius: BorderRadius.circular(7425),
																																		color: Color(0xD9FFFFFF),
																																		boxShadow: [
																																			BoxShadow(
																																				color: Color(0x0D000000),
																																				blurRadius: 1,
																																				offset: Offset(0, 0.7426701784133911),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 6, right: 6),
																																	margin: const EdgeInsets.only( bottom: 140),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(7425),
																																				),
																																				margin: const EdgeInsets.only( right: 2),
																																				width: 8,
																																				height: 8,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(7425),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xe86lwi0_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 8,
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
																										Text(
																											"Piring Artisan",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Text(
																											"Dinoyo Craft House",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.symmetric(vertical: 3),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										Text(
																											"Rp95.000",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9400),
																											),
																											width: 30,
																											height: 30,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9400),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/q87g7cg5_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 48, left: 5, right: 5),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(17),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																				margin: const EdgeInsets.only( right: 15),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 7),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( top: 14, right: 10),
																												margin: const EdgeInsets.only( bottom: 8),
																												width: double.infinity,
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(17),
																													image: DecorationImage(
																														image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/6z2tuiic_expires_30_days.png"),
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
																																		borderRadius: BorderRadius.circular(7425),
																																		color: Color(0xD9FFFFFF),
																																		boxShadow: [
																																			BoxShadow(
																																				color: Color(0x0D000000),
																																				blurRadius: 1,
																																				offset: Offset(0, 0.7426701784133911),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 1, bottom: 1, left: 6, right: 6),
																																	margin: const EdgeInsets.only( bottom: 140),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(7425),
																																				),
																																				margin: const EdgeInsets.only( right: 3),
																																				width: 8,
																																				height: 8,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(7425),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qsr7dgt1_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 8,
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
																										Text(
																											"Mangkuk Keramik",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Text(
																											"Ruang Tanah",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 11,
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
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										Text(
																											"Rp75.000",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9400),
																											),
																											width: 30,
																											height: 30,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9400),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xuigsghe_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
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
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(17),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 7),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( top: 14, right: 9),
																												margin: const EdgeInsets.only( bottom: 8),
																												width: double.infinity,
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(17),
																													image: DecorationImage(
																														image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/d9o3vvs7_expires_30_days.png"),
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
																																		borderRadius: BorderRadius.circular(7425),
																																		color: Color(0xD9FFFFFF),
																																		boxShadow: [
																																			BoxShadow(
																																				color: Color(0x0D000000),
																																				blurRadius: 1,
																																				offset: Offset(0, 0.7426701784133911),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 1, bottom: 1, left: 6, right: 6),
																																	margin: const EdgeInsets.only( bottom: 140),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(7425),
																																				),
																																				margin: const EdgeInsets.only( right: 2),
																																				width: 8,
																																				height: 8,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(7425),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/87op1cba_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"4.9",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 8,
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
																										Text(
																											"Piring Artisan",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Text(
																											"Dinoyo Craft House",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 11,
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
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									children: [
																										Text(
																											"Rp95.000",
																											style: TextStyle(
																												color: Color(0xFF1A1A1A),
																												fontSize: 13,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9400),
																											),
																											width: 30,
																											height: 30,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9400),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hel4gwm5_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
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