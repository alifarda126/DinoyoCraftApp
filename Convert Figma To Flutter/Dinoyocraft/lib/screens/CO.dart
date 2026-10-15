import 'package:flutter/material.dart';
class CO extends StatefulWidget {
	const CO({super.key});
	@override
	COState createState() => COState();
}
class COState extends State<CO> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pa9j0q0v_expires_30_days.png",
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
															padding: const EdgeInsets.only( top: 13, bottom: 13, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 16),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/na3hfr6l_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Checkout",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/7ekfpx8t_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 45, left: 17, right: 17),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
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
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 4),
																														width: 13,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9azh4vhg_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Text(
																														"Alamat Pengiriman",
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
																									Text(
																										"Mode Kosong",
																										style: TextStyle(
																											color: Color(0xFF5F5E5E),
																											fontSize: 12,
																											decoration: TextDecoration.underline,
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
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.all(17),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 3),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 28),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Expanded(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 8),
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Mochammad Al Mizan",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 14,
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
																																						borderRadius: BorderRadius.circular(4),
																																						color: Color(0xFF000000),
																																					),
																																					padding: const EdgeInsets.only( top: 1, bottom: 1, left: 8, right: 8),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"UTAMA",
																																								style: TextStyle(
																																									color: Color(0xFFFFFFFF),
																																									fontSize: 10,
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
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Row(
																																children: [
																																	Container(
																																		margin: const EdgeInsets.only( right: 4),
																																		width: 12,
																																		height: 12,
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lr55d149_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	),
																																	Text(
																																		"Ubah Alamat",
																																		style: TextStyle(
																																			color: Color(0xFF000000),
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
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 4),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 6),
																														width: 10,
																														height: 10,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mugtidev_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Text(
																														"0859-777-588-138",
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
																											margin: const EdgeInsets.only( bottom: 3),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 6),
																														width: 10,
																														height: 15,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nspq9r3u_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( right: 46),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			width: double.infinity,
																																			child: Text(
																																				"Jl. Sawiji Sari No.14, Kel. Mulyorejo, Kec.\nSukun, Kota Malang, Jawa Timur 65147",
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
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( top: 4),
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
																																			color: Color(0xFFCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(8),
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																	child: Row(
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(8),
																																				),
																																				margin: const EdgeInsets.only( right: 4),
																																				width: 9,
																																				height: 9,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(8),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ghm6qeei_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Tambah Alamat Baru",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 12,
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
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
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
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 4),
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kww07osm_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Text(
																														"Produk yang Dibeli (3)",
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
																									Text(
																										"2 Penjual Terpilih",
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
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.all(17),
																							margin: const EdgeInsets.only( bottom: 9),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(8),
																										),
																										margin: const EdgeInsets.only( right: 16),
																										width: 68,
																										height: 68,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(8),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/0f1g064d_expires_30_days.png",
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
																																padding: const EdgeInsets.only( bottom: 1),
																																margin: const EdgeInsets.only( bottom: 4),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Vas Keramik Minimalis",
																																							style: TextStyle(
																																								color: Color(0xFF1A1C1C),
																																								fontSize: 14,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 4),
																																											width: 11,
																																											height: 10,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zy7u9ncp_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																										Text(
																																											"Dinoyo Ceramic Studio",
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
																																				color: Color(0xFF000000),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
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
																																						borderRadius: BorderRadius.circular(8),
																																						color: Color(0xFFFFFFFF),
																																					),
																																					padding: const EdgeInsets.all(1),
																																					child: Row(
																																						children: [
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										padding: const EdgeInsets.only( top: 4, bottom: 4, left: 9, right: 9),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"-",
																																													style: TextStyle(
																																														color: Color(0xFF5F5E5E),
																																														fontSize: 14,
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
																																										padding: const EdgeInsets.only( left: 11, right: 11),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"1",
																																													style: TextStyle(
																																														color: Color(0xFF1A1C1C),
																																														fontSize: 14,
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
																																										padding: const EdgeInsets.only( top: 4, bottom: 4, left: 9, right: 9),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"+",
																																													style: TextStyle(
																																														color: Color(0xFF5F5E5E),
																																														fontSize: 14,
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
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.all(17),
																							width: double.infinity,
																							child: Row(
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													border: Border.all(
																														color: Color(0xFFCFC4C5),
																														width: 1,
																													),
																													borderRadius: BorderRadius.circular(8),
																													color: Color(0xFFFFFFFF),
																												),
																												padding: const EdgeInsets.only( left: 1, right: 1),
																												margin: const EdgeInsets.only( right: 16),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: 66,
																															height: 1,
																															child: SizedBox(),
																														),
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(8),
																															),
																															width: 66,
																															height: 67,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(8),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qrvjixbd_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
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
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Cangkir Handmade",
																																							style: TextStyle(
																																								color: Color(0xFF1A1C1C),
																																								fontSize: 14,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 4),
																																											width: 11,
																																											height: 10,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/aymhcx0b_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																										Text(
																																											"Karya Tanah",
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
																																				color: Color(0xFF000000),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
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
																																						borderRadius: BorderRadius.circular(8),
																																						color: Color(0xFFFFFFFF),
																																					),
																																					padding: const EdgeInsets.all(1),
																																					child: Row(
																																						children: [
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"-",
																																													style: TextStyle(
																																														color: Color(0xFF5F5E5E),
																																														fontSize: 14,
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
																																										padding: const EdgeInsets.only( left: 9, right: 9),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"2",
																																													style: TextStyle(
																																														color: Color(0xFF1A1C1C),
																																														fontSize: 14,
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
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"+",
																																													style: TextStyle(
																																														color: Color(0xFF5F5E5E),
																																														fontSize: 14,
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
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 4),
																										width: 18,
																										height: 13,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/s2hisrel_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Text(
																										"Metode Pengiriman",
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
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFF000000),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 13, bottom: 13, left: 12, right: 12),
																											margin: const EdgeInsets.only( bottom: 8),
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
																																			borderRadius: BorderRadius.circular(16),
																																		),
																																		margin: const EdgeInsets.only( right: 11),
																																		width: 18,
																																		height: 18,
																																		child: ClipRRect(
																																			borderRadius: BorderRadius.circular(16),
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9xwt9uim_expires_30_days.png",
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
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( right: 75),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Reguler",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																																fontWeight: FontWeight.bold,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									),
																																									Text(
																																										"Estimasi 2–4 hari kerja",
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
																																]
																															),
																														),
																													),
																													Text(
																														"Rp15.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
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
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(13),
																											margin: const EdgeInsets.only( bottom: 8),
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
																																			border: Border.all(
																																				color: Color(0xFF7E7576),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(16),
																																			color: Color(0xFFFFFFFF),
																																		),
																																		margin: const EdgeInsets.only( right: 12),
																																		width: 16,
																																		height: 16,
																																		child: SizedBox(),
																																	),
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Column(
																																				children: [
																																					IntrinsicWidth(
																																						child: IntrinsicHeight(
																																							child: Column(
																																								children: [
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( right: 82),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Hemat",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																																fontWeight: FontWeight.bold,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									),
																																									Text(
																																										"Estimasi 4–7 hari kerja",
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
																																]
																															),
																														),
																													),
																													Text(
																														"Rp10.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
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
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(13),
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
																																			border: Border.all(
																																				color: Color(0xFF7E7576),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(16),
																																			color: Color(0xFFFFFFFF),
																																		),
																																		margin: const EdgeInsets.only( right: 12),
																																		width: 16,
																																		height: 16,
																																		child: SizedBox(),
																																	),
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Column(
																																				children: [
																																					IntrinsicWidth(
																																						child: IntrinsicHeight(
																																							child: Column(
																																								children: [
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												padding: const EdgeInsets.only( right: 129),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Express",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 14,
																																																fontWeight: FontWeight.bold,
																																															),
																																														),
																																													]
																																												),
																																											),
																																										),
																																									),
																																									Text(
																																										"Estimasi 1–2 hari kerja (Prioritas)",
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
																																]
																															),
																														),
																													),
																													Text(
																														"Rp25.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
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
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 4),
																										width: 15,
																										height: 15,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/14og1i7c_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Text(
																										"Metode Pembayaran",
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
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFF000000),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(13),
																											margin: const EdgeInsets.only( bottom: 8),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 12),
																														width: 16,
																														height: 20,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gr48cb5j_expires_30_days.png",
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
																																		IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( bottom: 6),
																																				width: double.infinity,
																																				child: Row(
																																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 6),
																																											width: 15,
																																											height: 15,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rpadsvey_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																										Text(
																																											"QRIS Instant",
																																											style: TextStyle(
																																												color: Color(0xFF1A1C1C),
																																												fontSize: 14,
																																												fontWeight: FontWeight.bold,
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										IntrinsicWidth(
																																											child: IntrinsicHeight(
																																												child: Container(
																																													decoration: BoxDecoration(
																																														borderRadius: BorderRadius.circular(4),
																																														color: Color(0xFF000000),
																																													),
																																													padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																													margin: const EdgeInsets.only( right: 7),
																																													child: Column(
																																														crossAxisAlignment: CrossAxisAlignment.start,
																																														children: [
																																															Text(
																																																"DIREKOMENDASIKAN",
																																																style: TextStyle(
																																																	color: Color(0xFFFFFFFF),
																																																	fontSize: 10,
																																																	fontWeight: FontWeight.bold,
																																																),
																																															),
																																														]
																																													),
																																												),
																																											),
																																										),
																																										Container(
																																											width: 8,
																																											height: 5,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hdi8aruh_expires_30_days.png",
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
																																		IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( bottom: 5),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							width: double.infinity,
																																							child: Text(
																																								"Bayar instan bebas biaya admin dengan scan kode\nQRIS.",
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
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.symmetric(vertical: 6),
																																					width: double.infinity,
																																					child: Row(
																																						children: [
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										decoration: BoxDecoration(
																																											border: Border.all(
																																												color: Color(0xFFCFC4C5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(4),
																																											color: Color(0xFFFFFFFF),
																																											boxShadow: [
																																												BoxShadow(
																																													color: Color(0x0D000000),
																																													blurRadius: 2,
																																													offset: Offset(0, 1),
																																												),
																																											],
																																										),
																																										padding: const EdgeInsets.only( top: 2, bottom: 2, left: 7, right: 7),
																																										margin: const EdgeInsets.only( right: 6),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"QRIS",
																																													style: TextStyle(
																																														color: Color(0xFF000000),
																																														fontSize: 10,
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
																																											border: Border.all(
																																												color: Color(0xFFCFC4C5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(4),
																																											color: Color(0xFFFFFFFF),
																																											boxShadow: [
																																												BoxShadow(
																																													color: Color(0x0D000000),
																																													blurRadius: 2,
																																													offset: Offset(0, 1),
																																												),
																																											],
																																										),
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																										margin: const EdgeInsets.only( right: 6),
																																										child: Row(
																																											children: [
																																												Container(
																																													decoration: BoxDecoration(
																																														borderRadius: BorderRadius.circular(9999),
																																														color: Color(0xFF00AED6),
																																													),
																																													margin: const EdgeInsets.only( right: 4),
																																													width: 8,
																																													height: 8,
																																													child: SizedBox(),
																																												),
																																												Text(
																																													"GoPay",
																																													style: TextStyle(
																																														color: Color(0xFF00AED6),
																																														fontSize: 10,
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
																																											border: Border.all(
																																												color: Color(0xFFCFC4C5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(4),
																																											color: Color(0xFFFFFFFF),
																																											boxShadow: [
																																												BoxShadow(
																																													color: Color(0x0D000000),
																																													blurRadius: 2,
																																													offset: Offset(0, 1),
																																												),
																																											],
																																										),
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																										margin: const EdgeInsets.only( right: 7),
																																										child: Row(
																																											children: [
																																												Container(
																																													decoration: BoxDecoration(
																																														borderRadius: BorderRadius.circular(9999),
																																														color: Color(0xFF4C2A86),
																																													),
																																													margin: const EdgeInsets.only( right: 4),
																																													width: 8,
																																													height: 8,
																																													child: SizedBox(),
																																												),
																																												Text(
																																													"OVO",
																																													style: TextStyle(
																																														color: Color(0xFF4C2A86),
																																														fontSize: 10,
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
																																											border: Border.all(
																																												color: Color(0xFFCFC4C5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(4),
																																											color: Color(0xFFFFFFFF),
																																											boxShadow: [
																																												BoxShadow(
																																													color: Color(0x0D000000),
																																													blurRadius: 2,
																																													offset: Offset(0, 1),
																																												),
																																											],
																																										),
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																										margin: const EdgeInsets.only( right: 7),
																																										child: Row(
																																											children: [
																																												Container(
																																													decoration: BoxDecoration(
																																														borderRadius: BorderRadius.circular(9999),
																																														color: Color(0xFFEE4D2D),
																																													),
																																													margin: const EdgeInsets.only( right: 4),
																																													width: 8,
																																													height: 8,
																																													child: SizedBox(),
																																												),
																																												Text(
																																													"ShopeePay",
																																													style: TextStyle(
																																														color: Color(0xFFEE4D2D),
																																														fontSize: 10,
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
																																											border: Border.all(
																																												color: Color(0xFFCFC4C5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(4),
																																											color: Color(0xFFFFFFFF),
																																											boxShadow: [
																																												BoxShadow(
																																													color: Color(0x0D000000),
																																													blurRadius: 2,
																																													offset: Offset(0, 1),
																																												),
																																											],
																																										),
																																										padding: const EdgeInsets.only( top: 2, bottom: 2, left: 7, right: 7),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"BCA",
																																													style: TextStyle(
																																														color: Color(0xFF005EAA),
																																														fontSize: 10,
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
																												border: Border.all(
																													color: Color(0xFFCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(13),
																											margin: const EdgeInsets.only( bottom: 8),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 4),
																																margin: const EdgeInsets.only( right: 12),
																																child: Column(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFF7E7576),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(16),
																																				color: Color(0xFFFFFFFF),
																																			),
																																			width: 16,
																																			height: 16,
																																			child: SizedBox(),
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
																																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 6),
																																											width: 15,
																																											height: 15,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nz1gyuu1_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																										Text(
																																											"Virtual Account",
																																											style: TextStyle(
																																												color: Color(0xFF1A1C1C),
																																												fontSize: 14,
																																												fontWeight: FontWeight.bold,
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																						Container(
																																							width: 8,
																																							height: 5,
																																							child: Image.network(
																																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/uza9ip2i_expires_30_days.png",
																																								fit: BoxFit.fill,
																																							)
																																						),
																																					]
																																				),
																																			),
																																		),
																																		IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( bottom: 5),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Verifikasi otomatis 24 jam tanpa perlu bukti transfer.",
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
																																				padding: const EdgeInsets.symmetric(vertical: 6),
																																				width: double.infinity,
																																				child: Row(
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									decoration: BoxDecoration(
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																																									margin: const EdgeInsets.only( right: 6),
																																									child: Column(
																																										crossAxisAlignment: CrossAxisAlignment.start,
																																										children: [
																																											Text(
																																												"BCA",
																																												style: TextStyle(
																																													color: Color(0xFF005EAA),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																									margin: const EdgeInsets.only( right: 6),
																																									child: Row(
																																										children: [
																																											Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFFF5A623),
																																												),
																																												margin: const EdgeInsets.only( right: 4),
																																												width: 6,
																																												height: 6,
																																												child: SizedBox(),
																																											),
																																											Text(
																																												"Mandiri",
																																												style: TextStyle(
																																													color: Color(0xFF002D62),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																																									margin: const EdgeInsets.only( right: 7),
																																									child: Column(
																																										crossAxisAlignment: CrossAxisAlignment.start,
																																										children: [
																																											Text(
																																												"BRI",
																																												style: TextStyle(
																																													color: Color(0xFF085EA8),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																									child: Row(
																																										children: [
																																											Container(
																																												margin: const EdgeInsets.only( right: 3),
																																												child: Text(
																																													"BNI",
																																													style: TextStyle(
																																														color: Color(0xFFF15A24),
																																														fontSize: 10,
																																														fontWeight: FontWeight.bold,
																																													),
																																												),
																																											),
																																											IntrinsicWidth(
																																												child: IntrinsicHeight(
																																													child: Container(
																																														padding: const EdgeInsets.only( top: 1),
																																														child: Column(
																																															children: [
																																																Text(
																																																	"46",
																																																	style: TextStyle(
																																																		color: Color(0xFF006666),
																																																		fontSize: 9,
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
																												border: Border.all(
																													color: Color(0xFFCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.all(13),
																											width: double.infinity,
																											child: Row(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 4),
																																margin: const EdgeInsets.only( right: 12),
																																child: Column(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFF7E7576),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(16),
																																				color: Color(0xFFFFFFFF),
																																			),
																																			width: 16,
																																			height: 16,
																																			child: SizedBox(),
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
																																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											margin: const EdgeInsets.only( right: 6),
																																											width: 11,
																																											height: 16,
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/tlhwck0k_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										),
																																										Text(
																																											"E-Wallet",
																																											style: TextStyle(
																																												color: Color(0xFF1A1C1C),
																																												fontSize: 14,
																																												fontWeight: FontWeight.bold,
																																											),
																																										),
																																									]
																																								),
																																							),
																																						),
																																						Container(
																																							width: 8,
																																							height: 5,
																																							child: Image.network(
																																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kwkrew2z_expires_30_days.png",
																																								fit: BoxFit.fill,
																																							)
																																						),
																																					]
																																				),
																																			),
																																		),
																																		IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( bottom: 5),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							width: double.infinity,
																																							child: Text(
																																								"Terhubung langsung ke akun dompet digital favorit\nkamu.",
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
																																				padding: const EdgeInsets.symmetric(vertical: 6),
																																				width: double.infinity,
																																				child: Row(
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									decoration: BoxDecoration(
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																									margin: const EdgeInsets.only( right: 6),
																																									child: Row(
																																										children: [
																																											Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFFEE4D2D),
																																												),
																																												margin: const EdgeInsets.only( right: 4),
																																												width: 8,
																																												height: 8,
																																												child: SizedBox(),
																																											),
																																											Text(
																																												"ShopeePay",
																																												style: TextStyle(
																																													color: Color(0xFFEE4D2D),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																									margin: const EdgeInsets.only( right: 6),
																																									child: Row(
																																										children: [
																																											Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFF00AED6),
																																												),
																																												margin: const EdgeInsets.only( right: 4),
																																												width: 8,
																																												height: 8,
																																												child: SizedBox(),
																																											),
																																											Text(
																																												"GoPay",
																																												style: TextStyle(
																																													color: Color(0xFF00AED6),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																									margin: const EdgeInsets.only( right: 7),
																																									child: Row(
																																										children: [
																																											Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFF4C2A86),
																																												),
																																												margin: const EdgeInsets.only( right: 4),
																																												width: 8,
																																												height: 8,
																																												child: SizedBox(),
																																											),
																																											Text(
																																												"OVO",
																																												style: TextStyle(
																																													color: Color(0xFF4C2A86),
																																													fontSize: 10,
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
																																										border: Border.all(
																																											color: Color(0xFFCFC4C5),
																																											width: 1,
																																										),
																																										borderRadius: BorderRadius.circular(4),
																																										color: Color(0xFFFFFFFF),
																																										boxShadow: [
																																											BoxShadow(
																																												color: Color(0x0D000000),
																																												blurRadius: 2,
																																												offset: Offset(0, 1),
																																											),
																																										],
																																									),
																																									padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																									child: Row(
																																										children: [
																																											Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFF118EEA),
																																												),
																																												margin: const EdgeInsets.only( right: 4),
																																												width: 8,
																																												height: 8,
																																												child: SizedBox(),
																																											),
																																											Text(
																																												"DANA",
																																												style: TextStyle(
																																													color: Color(0xFF118EEA),
																																													fontSize: 10,
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
																			padding: const EdgeInsets.only( bottom: 6),
																			margin: const EdgeInsets.only( bottom: 24),
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
																										width: 13,
																										height: 9,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nxjc9m9a_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Text(
																										"Catatan untuk Penjual (Opsional)",
																										style: TextStyle(
																											color: Color(0xFF1A1C1C),
																											fontSize: 14,
																											fontWeight: FontWeight.bold,
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
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Contoh: Tolong bungkus dengan bubble wrap \ntebal dan kardus aman.",
																											style: TextStyle(
																												color: Color(0xFF5F5E5E),
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
																									Text(
																										"Ringkasan Pembayaran",
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
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.all(17),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Subtotal Produk",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 14,
																														),
																													),
																													Text(
																														"Rp215.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Biaya Pengiriman (Reguler)",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 14,
																														),
																													),
																													Text(
																														"Rp15.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Biaya Layanan",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 14,
																														),
																													),
																													Text(
																														"Rp2.000",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
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
																													Text(
																														"Total Pembayaran",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 16,
																															fontWeight: FontWeight.bold,
																														),
																													),
																													Text(
																														"Rp232.000",
																														style: TextStyle(
																															color: Color(0xFF000000),
																															fontSize: 18,
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
																color: Color(0x00FFFFFF),
																boxShadow: [
																	BoxShadow(
																		color: Color(0x1A000000),
																		blurRadius: 6,
																		offset: Offset(0, 4),
																	),
																],
															),
															padding: const EdgeInsets.all(16),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Column(
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( right: 26),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"Total Tagihan",
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
																					Text(
																						"Rp232.000",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 18,
																							fontWeight: FontWeight.bold,
																						),
																					),
																				]
																			),
																		),
																	),
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicWidth(
																			child: IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						borderRadius: BorderRadius.circular(9999),
																						color: Color(0xFF000000),
																						boxShadow: [
																							BoxShadow(
																								color: Color(0x0D000000),
																								blurRadius: 2,
																								offset: Offset(0, 1),
																							),
																						],
																					),
																					padding: const EdgeInsets.only( top: 12, bottom: 12, left: 28, right: 28),
																					child: Column(
																						children: [
																							Text(
																								"Bayar Sekarang",
																								style: TextStyle(
																									color: Color(0xFFFFFFFF),
																									fontSize: 14,
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