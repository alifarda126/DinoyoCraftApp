import 'package:flutter/material.dart';
class PopUpChatbot extends StatefulWidget {
	const PopUpChatbot({super.key});
	@override
	PopUpChatbotState createState() => PopUpChatbotState();
}
class PopUpChatbotState extends State<PopUpChatbot> {
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
											border: Border.all(
												color: Color(0xFFE5E5E5),
												width: 1,
											),
											borderRadius: BorderRadius.only(
												topLeft: Radius.circular(26),
												topRight: Radius.circular(26),
											),
											color: Color(0xFFFFFFFF),
										),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											padding: const EdgeInsets.only( top: 1),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 6),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(9999),
																		),
																		margin: const EdgeInsets.only( right: 9),
																		width: 36,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(9999),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rq6oupyi_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Column(
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Column(
																								children: [
																									Text(
																										"ClayBot",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 17,
																											fontWeight: FontWeight.bold,
																										),
																									),
																									Text(
																										"Asisten DinoyoCraft",
																										style: TextStyle(
																											color: Color(0xFF525252),
																											fontSize: 7,
																											fontWeight: FontWeight.bold,
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
																	Expanded(
																		child: Container(
																			width: double.infinity,
																			child: SizedBox(),
																		),
																	),
																	Container(
																		margin: const EdgeInsets.only( right: 73),
																		width: 36,
																		height: 20,
																		child: SizedBox(),
																	),
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(9999),
																		),
																		width: 32,
																		height: 32,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(9999),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pe6dm1c5_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 48, left: 17, right: 17),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( bottom: 118),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.symmetric(vertical: 1),
																										margin: const EdgeInsets.only( bottom: 13),
																										child: Row(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													width: 24,
																													height: 26,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hqjdvhm3_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												IntrinsicWidth(
																													child: IntrinsicHeight(
																														child: Container(
																															decoration: BoxDecoration(
																																border: Border.all(
																																	color: Color(0xFFE5E5E5),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.only(
																																	topLeft: Radius.circular(2),
																																	topRight: Radius.circular(16),
																																	bottomRight: Radius.circular(16),
																																	bottomLeft: Radius.circular(16),
																																),
																																color: Color(0xFFF5F5F5),
																															),
																															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																															margin: const EdgeInsets.symmetric(horizontal: 8),
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Container(
																																		margin: const EdgeInsets.only( bottom: 5),
																																		child: Text(
																																			"Halo! 👋",
																																			style: TextStyle(
																																				color: Color(0xFF000000),
																																				fontSize: 12,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	),
																																	Container(
																																		width: 224,
																																		child: Text(
																																			"Saya ClayBot, asisten DinoyoCraft.\nSaya siap membantu kamu menemukan\nproduk keramik lokal, mencari studio\ntoko, info jadwal workshop, hingga\nbantuan pesananmu.",
																																			style: TextStyle(
																																				color: Color(0xFF262626),
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
																							),
																							IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( left: 32),
																									margin: const EdgeInsets.only( bottom: 13),
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
																																"Apa yang ingin kamu cari?",
																																style: TextStyle(
																																	color: Color(0xFF525252),
																																	fontSize: 11,
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
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		margin: const EdgeInsets.only( bottom: 6),
																																		child: Row(
																																			children: [
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0xFFD4D4D4),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0xFFFFFFFF),
																																							),
																																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																							margin: const EdgeInsets.only( right: 6),
																																							child: Row(
																																								children: [
																																									Text(
																																										"🏺",
																																										style: TextStyle(
																																											color: Color(0xFF262626),
																																											fontSize: 11,
																																										),
																																									),
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( left: 4, right: 4),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Cari produk",
																																															style: TextStyle(
																																																color: Color(0xFF262626),
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
																																				),
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0xFF171717),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0xFF171717),
																																							),
																																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																							child: Row(
																																								children: [
																																									Text(
																																										"☕",
																																										style: TextStyle(
																																											color: Color(0xFFFFFFFF),
																																											fontSize: 11,
																																										),
																																									),
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( left: 4, right: 4),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Rekomendasi cangkir",
																																															style: TextStyle(
																																																color: Color(0xFFFFFFFF),
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
																																				),
																																			]
																																		),
																																	),
																																),
																															),
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		margin: const EdgeInsets.only( bottom: 7),
																																		child: Row(
																																			children: [
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0xFFD4D4D4),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0xFFFFFFFF),
																																							),
																																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																							margin: const EdgeInsets.only( right: 6),
																																							child: Row(
																																								children: [
																																									Text(
																																										"🏪",
																																										style: TextStyle(
																																											color: Color(0xFF262626),
																																											fontSize: 11,
																																										),
																																									),
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( left: 4, right: 4),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Cari toko",
																																															style: TextStyle(
																																																color: Color(0xFF262626),
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
																																				),
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0xFFD4D4D4),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0xFFFFFFFF),
																																							),
																																							padding: const EdgeInsets.only( top: 6, bottom: 6, left: 13, right: 21),
																																							child: Column(
																																								crossAxisAlignment: CrossAxisAlignment.start,
																																								children: [
																																									Text(
																																										"🎨",
																																										style: TextStyle(
																																											color: Color(0xFF262626),
																																											fontSize: 11,
																																										),
																																									),
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( left: 4, right: 4),
																																												margin: const EdgeInsets.only( left: 8),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Info workshop",
																																															style: TextStyle(
																																																color: Color(0xFF262626),
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
																																			border: Border.all(
																																				color: Color(0xFFD4D4D4),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(12),
																																			color: Color(0xFFFFFFFF),
																																		),
																																		padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																		child: Row(
																																			children: [
																																				Text(
																																					"📦",
																																					style: TextStyle(
																																						color: Color(0xFF262626),
																																						fontSize: 11,
																																					),
																																				),
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							padding: const EdgeInsets.only( left: 4, right: 4),
																																							child: Column(
																																								crossAxisAlignment: CrossAxisAlignment.start,
																																								children: [
																																									Text(
																																										"Bantuan pesanan",
																																										style: TextStyle(
																																											color: Color(0xFF262626),
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
																															),
																														]
																													),
																												),
																											),
																										]
																									),
																								),
																							),
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.symmetric(vertical: 5),
																										margin: const EdgeInsets.only( bottom: 13),
																										child: Row(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													width: 24,
																													height: 26,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cge5i3hl_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												),
																												InkWell(
																													onTap: () { print('Pressed'); },
																													child: IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																decoration: BoxDecoration(
																																	border: Border.all(
																																		color: Color(0xFFE5E5E5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.only(
																																		topLeft: Radius.circular(2),
																																		topRight: Radius.circular(16),
																																		bottomRight: Radius.circular(16),
																																		bottomLeft: Radius.circular(16),
																																	),
																																	color: Color(0xFFF5F5F5),
																																),
																																padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																																margin: const EdgeInsets.symmetric(horizontal: 8),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			width: 233,
																																			child: Text(
																																				"Ada produk keramik spesifik yang sedang\ningin kamu cari hari ini?",
																																				style: TextStyle(
																																					color: Color(0xFF262626),
																																					fontSize: 12,
																																				),
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
																							IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( top: 5, right: 1),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.end,
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.only(
																																topLeft: Radius.circular(16),
																																topRight: Radius.circular(2),
																																bottomRight: Radius.circular(16),
																																bottomLeft: Radius.circular(16),
																															),
																															color: Color(0xFF000000),
																															boxShadow: [
																																BoxShadow(
																																	color: Color(0x0D000000),
																																	blurRadius: 2,
																																	offset: Offset(0, 1),
																																),
																															],
																														),
																														padding: const EdgeInsets.only( top: 9, bottom: 9, left: 14, right: 14),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Container(
																																	margin: const EdgeInsets.only( bottom: 3),
																																	width: 211,
																																	child: Text(
																																		"Saya sedang mencari cangkir keramik\nhandmade.",
																																		style: TextStyle(
																																			color: Color(0xFFFFFFFF),
																																			fontSize: 12,
																																		),
																																	),
																																),
																																IntrinsicWidth(
																																	child: IntrinsicHeight(
																																		child: Container(
																																			padding: const EdgeInsets.only( left: 221),
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Text(
																																						"10:42",
																																						style: TextStyle(
																																							color: Color(0xFFA3A3A3),
																																							fontSize: 9,
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
																						]
																					),
																				),
																			),
																		]
																	),
																	Positioned(
																		bottom: 0,
																		left: 0,
																		child: IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( top: 5),
																					transform: Matrix4.translationValues(0, 201, 0),
																					child: Column(
																						children: [
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Row(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												margin: const EdgeInsets.only( right: 8),
																												width: 24,
																												height: 26,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wajoow18_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											IntrinsicWidth(
																												child: IntrinsicHeight(
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
																																					color: Color(0xFFE5E5E5),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.only(
																																					topLeft: Radius.circular(2),
																																					topRight: Radius.circular(16),
																																					bottomRight: Radius.circular(16),
																																					bottomLeft: Radius.circular(16),
																																				),
																																				color: Color(0xFFF5F5F5),
																																			),
																																			padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																																			margin: const EdgeInsets.only( bottom: 8),
																																			child: Column(
																																				children: [
																																					Container(
																																						width: 240,
																																						child: Text(
																																							"Tentu! Saya menemukan beberapa pilihan\ncangkir terfavorit langsung dari pengrajin\nlokal Dinoyo:",
																																							style: TextStyle(
																																								color: Color(0xFF262626),
																																								fontSize: 12,
																																							),
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
																	Positioned(
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				color: Color(0xFFFFFFFF),
																				padding: const EdgeInsets.symmetric(vertical: 12),
																				transform: Matrix4.translationValues(16, 64, 0),
																				width: double.infinity,
																				child: Column(
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 8, left: 12, right: 12),
																								width: double.infinity,
																								child: Row(
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9999),
																											),
																											margin: const EdgeInsets.only( right: 8),
																											width: 40,
																											height: 40,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9999),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ylrs1dx8_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													alignment: Alignment.center,
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xFFD4D4D4),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(9999),
																														color: Color(0xFFF5F5F5),
																													),
																													width: double.infinity,
																													child: TextField(
																														style: TextStyle(
																															color: Color(0xFFA3A3A3),
																															fontSize: 12,
																														),
																														onChanged: (value) { 
																															setState(() { textField1 = value; });
																														},
																														decoration: InputDecoration(
																															hintText: "Tulis pesan kamu...",
																															isDense: true,
																															contentPadding: const EdgeInsets.only( top: 14, bottom: 14, left: 17, right: 17),
																															border: InputBorder.none,
																															focusedBorder: InputBorder.none,
																															filled: false,
																														),
																													),
																												),
																											),
																										),
																										Container(
																											width: 52,
																											height: 44,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ap2j4ytz_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																									]
																								),
																							),
																						),
																						Text(
																							"ClayBot memiliki batasan tertentu, cerdaslah dalam bertanya..",
																							style: TextStyle(
																								color: Color(0xFFA3A3A3),
																								fontSize: 9,
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