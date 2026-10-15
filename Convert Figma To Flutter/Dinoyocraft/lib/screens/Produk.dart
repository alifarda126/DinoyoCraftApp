import 'package:flutter/material.dart';
class Produk extends StatefulWidget {
	const Produk({super.key});
	@override
	ProdukState createState() => ProdukState();
}
class ProdukState extends State<Produk> {
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
																				padding: const EdgeInsets.only( left: 29, right: 29),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zotsmnnp_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 13),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/b4b4q9zu_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9h6ffzzr_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3vho76vb_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/tabuqarq_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 20, left: 22, right: 22),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Text(
																						"Produk Keramik",
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
																	Container(
																		width: double.infinity,
																		child: Text(
																			"Temukan berbagai karya keramik dari pengrajin lokal\nDinoyo.",
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
															decoration: BoxDecoration(
																border: Border.all(
																	color: Color(0xFFCCCCCC),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 12, left: 22, right: 22),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 13),
																		width: 16,
																		height: 16,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a1bxgh4f_expires_30_days.png",
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
																							"Cari produk keramik...",
																							style: TextStyle(
																								color: Color(0xFFCCCCCC),
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
													IntrinsicWidth(
														child: IntrinsicHeight(
															child: Container(
																margin: const EdgeInsets.only( bottom: 11),
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
																								border: Border.all(
																									color: Color(0xFF000000),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFF000000),
																							),
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 17, right: 17),
																							margin: const EdgeInsets.only( right: 8),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Semua",
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
																									color: Color(0xFFCCCCCC),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																							margin: const EdgeInsets.only( right: 8),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Vas",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
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
																									color: Color(0xFFCCCCCC),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																							margin: const EdgeInsets.only( right: 8),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Cangkir",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
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
																									color: Color(0xFFCCCCCC),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																							margin: const EdgeInsets.only( right: 7),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Piring",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
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
																									color: Color(0xFFCCCCCC),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Mangkuk",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
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
															margin: const EdgeInsets.only( bottom: 15, left: 6, right: 6),
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
																				padding: const EdgeInsets.all(14),
																				margin: const EdgeInsets.only( right: 16),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9bl8vs9a_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/op5asvn6_expires_30_days.png",
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
																												padding: const EdgeInsets.only( top: 13, bottom: 141, left: 9, right: 9),
																												margin: const EdgeInsets.only( bottom: 8),
																												width: double.infinity,
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(17),
																													image: DecorationImage(
																														image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ep6smhd9_expires_30_days.png"),
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
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 5, right: 5),
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
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/eo0440yo_expires_30_days.png",
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
																																	padding: const EdgeInsets.only( top: 1, bottom: 1, left: 5, right: 5),
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
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lq47y0zn_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/1vydqorf_expires_30_days.png",
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
															margin: const EdgeInsets.symmetric(horizontal: 6),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Row(
																		children: [
																			Expanded(
																				child: IntrinsicHeight(
																					child: Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(17),
																							color: Color(0xFFFFFFFF),
																						),
																						margin: const EdgeInsets.only( right: 16),
																						width: double.infinity,
																						child: Stack(
																							clipBehavior: Clip.none,
																							children: [
																								Padding(
																									padding: const EdgeInsets.only( top: 13, left: 14, right: 14),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( top: 14, right: 9),
																													margin: const EdgeInsets.only( bottom: 89),
																													width: double.infinity,
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(17),
																														image: DecorationImage(
																															image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/08rdfk6n_expires_30_days.png"),
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
																																		padding: const EdgeInsets.only( top: 2, bottom: 2, left: 5, right: 5),
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
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/dljfjxo6_expires_30_days.png",
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
																										]
																									),
																								),
																								Positioned(
																									bottom: 42,
																									right: 42,
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
																													padding: const EdgeInsets.only( top: 14, bottom: 14, left: 13, right: 13),
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/eei2j02s_expires_30_days.png",
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
																			),
																			Expanded(
																				child: IntrinsicHeight(
																					child: Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(17),
																							color: Color(0xFFFFFFFF),
																						),
																						padding: const EdgeInsets.only( top: 13, left: 13, right: 13),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicHeight(
																									child: Container(
																										margin: const EdgeInsets.only( bottom: 55),
																										width: double.infinity,
																										child: Stack(
																											clipBehavior: Clip.none,
																											children: [
																												Padding(
																													padding: const EdgeInsets.only( bottom: 34),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 14, right: 8),
																																	width: double.infinity,
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(17),
																																		image: DecorationImage(
																																			image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/89xkfbee_expires_30_days.png"),
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
																																						padding: const EdgeInsets.only( top: 2, bottom: 2, left: 5, right: 5),
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
																																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/j1jnex24_expires_30_days.png",
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
																														]
																													),
																												),
																												Positioned(
																													bottom: 34,
																													right: 0,
																													width: 52,
																													height: 57,
																													child: Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(8905),
																														),
																														width: 52,
																														height: 57,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(8905),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/434m0s51_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
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
																	Positioned(
																		bottom: 13,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(10),
																					color: Color(0x80FFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 10, bottom: 10, left: 29, right: 29),
																				transform: Matrix4.translationValues(6, 0, 0),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Row(
																									children: [
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( right: 25),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9c7snyiw_expires_30_days.png",
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
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( top: 30, left: 4, right: 40),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Produk",
																																style: TextStyle(
																																	color: Color(0xFF000000),
																																	fontSize: 11,
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
																													margin: const EdgeInsets.only( right: 41),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rneo4llz_expires_30_days.png",
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
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( right: 41),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9p6qg42j_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															Text(
																																"Workshop",
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
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															margin: const EdgeInsets.only( bottom: 4),
																															width: 20,
																															height: 20,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/63nwno8v_expires_30_days.png",
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