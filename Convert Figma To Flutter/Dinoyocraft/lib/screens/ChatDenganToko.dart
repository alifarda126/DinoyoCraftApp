import 'package:flutter/material.dart';
class ChatDenganToko extends StatefulWidget {
	const ChatDenganToko({super.key});
	@override
	ChatDenganTokoState createState() => ChatDenganTokoState();
}
class ChatDenganTokoState extends State<ChatDenganToko> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/16irq563_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 8, bottom: 8, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 19),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 19),
																		width: 21,
																		height: 25,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vcb0nglf_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( top: 28, left: 28, right: 1),
																				margin: const EdgeInsets.only( right: 13),
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(40),
																					image: DecorationImage(
																						image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nohmeahn_expires_30_days.png"),
																						fit: BoxFit.fill
																					),
																				),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFFFFFFF),
																									width: 2,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFF059669),
																							),
																							margin: const EdgeInsets.only( bottom: 1),
																							width: 10,
																							height: 10,
																							child: SizedBox(),
																						),
																					]
																				),
																			),
																		),
																	),
																	Text(
																		"Dinoyo Ceramic Studio",
																		style: TextStyle(
																			color: Color(0xFF1A1C1C),
																			fontSize: 16,
																			fontWeight: FontWeight.bold,
																		),
																	),
																	Expanded(
																		child: Container(
																			width: double.infinity,
																			child: SizedBox(),
																		),
																	),
																	Container(
																		width: 24,
																		height: 28,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gtpctcil_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 16, left: 16, right: 16),
															width: double.infinity,
															child: Column(
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
																						color: Color(0xFFFFFFFF),
																					),
																					padding: const EdgeInsets.only( top: 5, bottom: 5, left: 12, right: 12),
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							Text(
																								"Hari ini, 14:10",
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
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.symmetric(horizontal: 19),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( bottom: 1),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( bottom: 16),
																										child: Row(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( top: 123, right: 8),
																													width: 28,
																													height: 32,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nyv2b3w8_expires_30_days.png",
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
																																						color: Color(0xFFCFC4C5),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.only(
																																						topLeft: Radius.circular(16),
																																						topRight: Radius.circular(16),
																																						bottomRight: Radius.circular(16),
																																						bottomLeft: Radius.circular(2),
																																					),
																																					color: Color(0xFFFFFFFF),
																																					boxShadow: [
																																						BoxShadow(
																																							color: Color(0x0D000000),
																																							blurRadius: 2,
																																							offset: Offset(0, 1),
																																						),
																																					],
																																				),
																																				padding: const EdgeInsets.all(15),
																																				margin: const EdgeInsets.only( bottom: 4),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							width: 226,
																																							child: Text(
																																								"Halo Kak Mochammad! Terima kasih\nsudah menghubungi Dinoyo Ceramic\nStudio. Ada yang bisa kami bantu\nterkait produk tembikar dan keramik\nkami? 😊",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 13,
																																								),
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
																																			padding: const EdgeInsets.only( left: 4, right: 4),
																																			margin: const EdgeInsets.only( right: 240),
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Text(
																																						"14:12",
																																						style: TextStyle(
																																							color: Color(0xFF5F5E5E),
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
																							IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 16),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.end,
																										children: [
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
																																				borderRadius: BorderRadius.only(
																																					topLeft: Radius.circular(16),
																																					topRight: Radius.circular(16),
																																					bottomRight: Radius.circular(2),
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
																																			padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
																																			margin: const EdgeInsets.only( bottom: 4),
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Container(
																																						width: 273,
																																						child: Text(
																																							"Halo min, untuk Vas Keramik Minimalis warna\nSand White Glossy apakah ready stock untuk\npengiriman ke Surabaya? Apakah packing\nkayunya dijamin aman?",
																																							style: TextStyle(
																																								color: Color(0xFFFFFFFF),
																																								fontSize: 13,
																																							),
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
																																		margin: const EdgeInsets.only( left: 259),
																																		child: Column(
																																			children: [
																																				IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Row(
																																							children: [
																																								Container(
																																									margin: const EdgeInsets.only( right: 4),
																																									child: Text(
																																										"14:15",
																																										style: TextStyle(
																																											color: Color(0xFF5F5E5E),
																																											fontSize: 10,
																																										),
																																									),
																																								),
																																								Container(
																																									width: 11,
																																									height: 6,
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gqzn4rfx_expires_30_days.png",
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
																										]
																									),
																								),
																							),
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( bottom: 16),
																										child: Row(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( top: 122, right: 8),
																													width: 28,
																													height: 31,
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/v60i85nh_expires_30_days.png",
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
																																						color: Color(0xFFCFC4C5),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.only(
																																						topLeft: Radius.circular(16),
																																						topRight: Radius.circular(16),
																																						bottomRight: Radius.circular(16),
																																						bottomLeft: Radius.circular(2),
																																					),
																																					color: Color(0xFFFFFFFF),
																																					boxShadow: [
																																						BoxShadow(
																																							color: Color(0x0D000000),
																																							blurRadius: 2,
																																							offset: Offset(0, 1),
																																						),
																																					],
																																				),
																																				padding: const EdgeInsets.all(15),
																																				margin: const EdgeInsets.only( bottom: 3),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							width: 232,
																																							child: Text(
																																								"Ready stock kak! Untuk pengiriman\nluar kota kami selalu lapis bubble wrap\ntebal 3 lapis dan rangka kayu\npengaman. Dijamin aman sampai\ntujuan tanpa retak kak 👍",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 13,
																																								),
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
																																			padding: const EdgeInsets.only( left: 4, right: 4),
																																			margin: const EdgeInsets.only( right: 240),
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Text(
																																						"14:16",
																																						style: TextStyle(
																																							color: Color(0xFF5F5E5E),
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
																							IntrinsicWidth(
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											border: Border.all(
																												color: Color(0xFFCFC4C5),
																												width: 1,
																											),
																											borderRadius: BorderRadius.only(
																												topLeft: Radius.circular(16),
																												topRight: Radius.circular(16),
																												bottomRight: Radius.circular(16),
																												bottomLeft: Radius.circular(2),
																											),
																											color: Color(0xFFFFFFFF),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x0D000000),
																													blurRadius: 2,
																													offset: Offset(0, 1),
																												),
																											],
																										),
																										padding: const EdgeInsets.only( top: 9, left: 9, right: 9),
																										margin: const EdgeInsets.only( left: 36),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												IntrinsicWidth(
																													child: IntrinsicHeight(
																														child: Container(
																															decoration: BoxDecoration(
																																border: Border.all(
																																	color: Color(0xFFCFC4C5),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(12),
																															),
																															padding: const EdgeInsets.only( top: 1, left: 1, right: 1),
																															margin: const EdgeInsets.only( bottom: 23),
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Container(
																																		decoration: BoxDecoration(
																																			borderRadius: BorderRadius.circular(12),
																																		),
																																		width: 246,
																																		height: 176,
																																		child: ClipRRect(
																																			borderRadius: BorderRadius.circular(12),
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/4z5josbl_expires_30_days.png",
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
																				color: Color(0xF0FFFFFF),
																				padding: const EdgeInsets.only( top: 1),
																				transform: Matrix4.translationValues(19, 0, 0),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								color: Color(0xFFFAF9F9),
																								padding: const EdgeInsets.only( top: 10, bottom: 10, left: 16, right: 16),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/aablwlkc_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xFFCFC4C5),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(9999),
																														color: Color(0xFFFFFFFF),
																													),
																													padding: const EdgeInsets.only( top: 12, bottom: 12, left: 17, right: 17),
																													margin: const EdgeInsets.only( right: 8),
																													width: double.infinity,
																													child: Row(
																														mainAxisAlignment: MainAxisAlignment.spaceBetween,
																														children: [
																															Text(
																																"Ketik pesan...",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
																																	fontSize: 13,
																																),
																															),
																															Container(
																																width: 16,
																																height: 16,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ih4meo0c_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																														]
																													),
																												),
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9999),
																											),
																											width: 44,
																											height: 44,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9999),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/sg6fw591_expires_30_days.png",
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