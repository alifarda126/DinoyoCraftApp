import 'package:flutter/material.dart';
class Workshop extends StatefulWidget {
	const Workshop({super.key});
	@override
	WorkshopState createState() => WorkshopState();
}
class WorkshopState extends State<Workshop> {
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
															margin: const EdgeInsets.only( bottom: 6, left: 7, right: 7),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vjq1qs6q_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.only(
																	topLeft: Radius.circular(25),
																	topRight: Radius.circular(25),
																),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.symmetric(vertical: 5),
															margin: const EdgeInsets.only( bottom: 25),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( left: 5),
																				child: Column(
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( bottom: 12),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												width: 46,
																												height: 46,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ntl8lmzj_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( left: 43),
																												child: Text(
																													"DinoyoCraft",
																													style: TextStyle(
																														color: Color(0xFF1A1A1A),
																														fontSize: 16,
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
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 16),
																				child: Row(
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 36,
																							height: 36,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3tngjvzl_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 36,
																							height: 36,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/duosacy6_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																							),
																							width: 40,
																							height: 40,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(9999),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/k7qxcj4e_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
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
															margin: const EdgeInsets.only( bottom: 24, left: 21, right: 21),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 5),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Text(
																						"Workshop Keramik Dinoyo",
																						style: TextStyle(
																							color: Color(0xFF1A1A1A),
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
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						width: double.infinity,
																						child: Text(
																							"Rasakan pengalaman membuat keramik langsung\nbersama pengrajin lokal.",
																							style: TextStyle(
																								color: Color(0xFF1A1A1A),
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
															margin: const EdgeInsets.only( bottom: 17, left: 1, right: 1),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						gradient: LinearGradient(
																							begin: Alignment(-1, -1),
																							end: Alignment(-1, 1),
																							colors: [
																								Color(0x99000000),
																								Color(0x00000000),
																								Color(0x33000000),
																							],
																						),
																					),
																					padding: const EdgeInsets.only( top: 219, bottom: 10, left: 9, right: 9),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Text(
																												"Pengrajin Sedang Membentuk Tanah Liat",
																												style: TextStyle(
																													color: Color(0xFFFFFFFF),
																													fontSize: 14,
																													fontWeight: FontWeight.bold,
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 111),
																												child: Text(
																													"Kampung Keramik Dinoyo Malang",
																													style: TextStyle(
																														color: Color(0xFFFFFFFF),
																														fontSize: 11,
																														fontWeight: FontWeight.bold,
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
																	Positioned(
																		top: 0,
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: Container(
																			width: double.infinity,
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/itgwfoqb_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
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
																	color: Color(0xFFCCCCCC),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(16),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.all(17),
															margin: const EdgeInsets.only( bottom: 24, left: 21, right: 21),
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
																						"Pengalaman Membuat Keramik",
																						style: TextStyle(
																							color: Color(0xFF1A1A1A),
																							fontSize: 18,
																							fontWeight: FontWeight.bold,
																						),
																					),
																				]
																			),
																		),
																	),
																	Container(
																		width: double.infinity,
																		child: Text(
																			"Luangkan waktu bersama teman atau keluarga\nuntuk mencoba membuat keramik secara\nlangsung. Belajar dari pengrajin lokal, mencoba\nproses pembuatan keramik, dan membawa\npulang pengalaman yang berkesan dari Dinoyo.",
																			style: TextStyle(
																				color: Color(0xFF1A1A1A),
																				fontSize: 14,
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.symmetric(horizontal: 21),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( bottom: 60, right: 19),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							Container(
																								margin: const EdgeInsets.only( bottom: 3),
																								child: Text(
																									"Ingin Ikut Workshop?",
																									style: TextStyle(
																										color: Color(0xFF1A1A1A),
																										fontSize: 18,
																										fontWeight: FontWeight.bold,
																									),
																								),
																							),
																							IntrinsicHeight(
																								child: Container(
																									width: double.infinity,
																									child: Stack(
																										clipBehavior: Clip.none,
																										children: [
																											Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: 331,
																														child: Text(
																															"Hubungi contact person untuk mengetahui jadwal,\nharga, dan ketersediaan workshop.",
																															style: TextStyle(
																																color: Color(0xFF666666),
																																fontSize: 14,
																															),
																														),
																													),
																												]
																											),
																											Positioned(
																												bottom: 19,
																												right: 0,
																												width: 57,
																												height: 57,
																												child: Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(8905),
																													),
																													transform: Matrix4.translationValues(21, 0, 0),
																													width: 57,
																													height: 57,
																													child: ClipRRect(
																														borderRadius: BorderRadius.circular(8905),
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/i5dykbf9_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													)
																												),
																											),
																											Positioned(
																												top: 30,
																												right: 60,
																												child: InkWell(
																													onTap: () { print('Pressed'); },
																													child: IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(9999),
																																	color: Color(0x00FFFFFF),
																																	boxShadow: [
																																		BoxShadow(
																																			color: Color(0x1A000000),
																																			blurRadius: 4,
																																			offset: Offset(0, 2),
																																		),
																																	],
																																),
																																padding: const EdgeInsets.all(14),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(9999),
																																			),
																																			width: 20,
																																			height: 20,
																																			child: ClipRRect(
																																				borderRadius: BorderRadius.circular(9999),
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/em0zhzcb_expires_30_days.png",
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
																	Positioned(
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(10),
																					color: Color(0x80FFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 12, bottom: 12, left: 30, right: 30),
																				transform: Matrix4.translationValues(21, 0, 0),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( right: 29),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/o80r0729_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															Text(
																																"Beranda",
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
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( top: 1, right: 48),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/atq56u22_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															Text(
																																"Produk",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 10,
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
																													margin: const EdgeInsets.only( top: 1, right: 36),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/b7tfonrz_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															Text(
																																"Toko",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 10,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																										Expanded(
																											child: Container(
																												margin: const EdgeInsets.only( top: 27, right: 38),
																												width: double.infinity,
																												child: Text(
																													"Workshop",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 11,
																														fontWeight: FontWeight.bold,
																													),
																													textAlign: TextAlign.center,
																												),
																											),
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( top: 1),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8jb1ljfo_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															Text(
																																"Profil",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 10,
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