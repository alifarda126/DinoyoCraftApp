import 'package:flutter/material.dart';
class Ulasan extends StatefulWidget {
	const Ulasan({super.key});
	@override
	UlasanState createState() => UlasanState();
}
class UlasanState extends State<Ulasan> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nqwyp233_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 11),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wn0k9uik_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Ulasan Toko",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/q8gg0srg_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 20, left: 17, right: 17),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 2),
																						child: Text(
																							"Ulasan Pelanggan",
																							style: TextStyle(
																								color: Color(0xFF1A1C1C),
																								fontSize: 18,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( right: 19),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"Dinoyo Ceramic Studio ",
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
																	IntrinsicWidth(
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
																				padding: const EdgeInsets.only( top: 5, bottom: 5, left: 11, right: 11),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"Terverifikasi",
																							style: TextStyle(
																								color: Color(0xFF4C4546),
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
															margin: const EdgeInsets.only( bottom: 20, left: 17, right: 17),
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gtet30fm_expires_30_days.png",
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
																			padding: const EdgeInsets.only( top: 13, bottom: 13, left: 12, right: 12),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						margin: const EdgeInsets.only( right: 8),
																						width: 15,
																						height: 15,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xkviixd1_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( right: 30),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											width: double.infinity,
																											child: Text(
																												"98% pembeli merekomendasikan produk\nstudio ini",
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
													IntrinsicWidth(
														child: IntrinsicHeight(
															child: Container(
																margin: const EdgeInsets.only( bottom: 16),
																width: double.infinity,
																child: SingleChildScrollView(
																	scrollDirection: Axis.horizontal,
																	child: Row(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
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
																							padding: const EdgeInsets.only( top: 6, bottom: 6, left: 16, right: 16),
																							margin: const EdgeInsets.only( right: 15),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Semua (12)",
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
																			),
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
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																							margin: const EdgeInsets.only( right: 17),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Bintang 5 (8)",
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
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																							margin: const EdgeInsets.only( right: 15),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Bintang 4 (4)",
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
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Bintang 3 (2)",
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
																		],
																	)
																),
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( bottom: 1, left: 16, right: 16),
															margin: const EdgeInsets.symmetric(horizontal: 1),
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
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lcc80ksq_expires_30_days.png",
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
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/z8sq7tmf_expires_30_days.png",
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
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/h0tap98p_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mbip6uk0_expires_30_days.png",
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
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 7, left: 17),
																								child: Row(
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(13),
																											),
																											margin: const EdgeInsets.only( right: 5),
																											width: 142,
																											height: 142,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(13),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8ug5gzpi_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(10),
																											),
																											width: 142,
																											height: 142,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(10),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/f542j6q3_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
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
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/j93uvn6g_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Container(
																														margin: const EdgeInsets.only( right: 6),
																														child: Text(
																															"Dinoyo Ceramic Studio",
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
																			margin: const EdgeInsets.only( bottom: 16),
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
																																				"AN",
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
																																				"Anisa Nur Azizah",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 14,
																																				),
																																			),
																																		),
																																		Container(
																																			margin: const EdgeInsets.only( right: 37),
																																			child: Text(
																																				"10 Feb 2025",
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
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9ashrbr3_expires_30_days.png",
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
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mjjd0eaf_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									IntrinsicHeight(
																										child: Container(
																											padding: const EdgeInsets.only( right: 40),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: double.infinity,
																														child: Text(
																															"Varian: Rustic Speckle  - Cangkir Kopi Handmade",
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
																							padding: const EdgeInsets.only( bottom: 3),
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Tekstur tanah liatnya terasa otentik dan berbobot",
																										style: TextStyle(
																											color: Color(0xFF1A1C1C),
																											fontSize: 14,
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"pas di tangan saat minum kopi seduh manual.",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Finishing matte-nya nyaman banget dipegang.",
																											style: TextStyle(
																												color: Color(0xFF1A1C1C),
																												fontSize: 14,
																											),
																										),
																									),
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Recomended untuk penikmat tembikar seni.",
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/l8tn125f_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Text(
																																"Membantu (9)",
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
																										"Membantu 9 orang",
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
																			padding: const EdgeInsets.only( top: 17, left: 17, right: 17),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
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
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFFEEEEEE),
																												),
																												padding: const EdgeInsets.only( top: 11, left: 11, right: 11),
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
																									IntrinsicWidth(
																										child: IntrinsicHeight(
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
																								]
																							),
																						),
																					),
																					Container(
																						width: 2,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kvfch4n5_expires_30_days.png",
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