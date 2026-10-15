import 'package:flutter/material.dart';
class Beranda extends StatefulWidget {
	const Beranda({super.key});
	@override
	BerandaState createState() => BerandaState();
}
class BerandaState extends State<Beranda> {
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
																				padding: const EdgeInsets.only( left: 31, right: 31),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/d3uyip7j_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0x1AFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 5),
															margin: const EdgeInsets.only( bottom: 21),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/eptgrf0q_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hlk3i1zi_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/epyvd13w_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/s8e5p088_expires_30_days.png",
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
													Container(
														margin: const EdgeInsets.only( bottom: 12, left: 21),
														child: Text(
															"Sentra Keramik Dinoyo, Kota Malang",
															style: TextStyle(
																color: Color(0xFF1A1A1A),
																fontSize: 12,
																fontWeight: FontWeight.bold,
															),
														),
													),
													Container(
														margin: const EdgeInsets.only( bottom: 10, left: 21, right: 21),
														width: double.infinity,
														child: Text(
															"Tanah liat Dinoyo, dari roda\npemutar langsung ke\ntanganmu.",
															style: TextStyle(
																color: Color(0xFF1A1A1A),
																fontSize: 24,
																fontWeight: FontWeight.bold,
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( bottom: 5),
															margin: const EdgeInsets.only( bottom: 8, left: 21, right: 21),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		width: double.infinity,
																		child: Text(
																			"Temukan karya keramik lokal dan pengalaman kreatif\ndari pengrajin Dinoyo.",
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
															margin: const EdgeInsets.only( bottom: 26),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			Container(
																				height: 219,
																				width: double.infinity,
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/uxf7i7u3_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			),
																		]
																	),
																	Positioned(
																		top: 4,
																		left: 1,
																		right: 1,
																		height: 219,
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(25),
																			),
																			height: 219,
																			width: double.infinity,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(25),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/okoq6hie_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			)
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( left: 20, right: 20),
															margin: const EdgeInsets.only( bottom: 12, left: 1, right: 1),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Text(
																		"Jelajahi Kategori",
																		style: TextStyle(
																			color: Color(0xFF1A1A1A),
																			fontSize: 18,
																			fontWeight: FontWeight.bold,
																		),
																	),
																	Text(
																		"Lihat Semua",
																		style: TextStyle(
																			color: Color(0xFF1A1A1A),
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
															margin: const EdgeInsets.only( bottom: 84),
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
																						padding: const EdgeInsets.only( top: 9, bottom: 9, left: 17, right: 17),
																						margin: const EdgeInsets.only( left: 20, right: 8),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Semua",
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
																						padding: const EdgeInsets.only( top: 9, bottom: 9, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 7),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Vas",
																									style: TextStyle(
																										color: Color(0xFF1A1A1A),
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
																						padding: const EdgeInsets.only( top: 9, bottom: 9, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 8),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Cangkir",
																									style: TextStyle(
																										color: Color(0xFF1A1A1A),
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
																						padding: const EdgeInsets.only( top: 9, bottom: 9, left: 16, right: 16),
																						margin: const EdgeInsets.only( right: 7),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Piring",
																									style: TextStyle(
																										color: Color(0xFF1A1A1A),
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
																						padding: const EdgeInsets.only( top: 9, bottom: 9, left: 16, right: 16),
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Mangkuk",
																									style: TextStyle(
																										color: Color(0xFF1A1A1A),
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
																	],
																)
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.symmetric(horizontal: 5),
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
																						padding: const EdgeInsets.only( top: 13, left: 13, right: 13),
																						margin: const EdgeInsets.only( right: 16),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.only( top: 60, bottom: 60, left: 3),
																										margin: const EdgeInsets.only( bottom: 89),
																										width: double.infinity,
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(17),
																											image: DecorationImage(
																												image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wov6n7m5_expires_30_days.png"),
																												fit: BoxFit.fill
																											),
																										),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												InkWell(
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ydr9zh67_expires_30_days.png",
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
																						padding: const EdgeInsets.only( top: 13, bottom: 89, left: 13, right: 13),
																						width: double.infinity,
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.only( top: 13, bottom: 141, left: 9, right: 9),
																										width: double.infinity,
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(17),
																											image: DecorationImage(
																												image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ax3qjxl8_expires_30_days.png"),
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5rbms2f9_expires_30_days.png",
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3lvirtbs_expires_30_days.png",
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
																				padding: const EdgeInsets.only( bottom: 44, left: 16, right: 16),
																				transform: Matrix4.translationValues(0, -56, 0),
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
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															margin: const EdgeInsets.only( right: 97),
																															child: Text(
																																"Pilihan Untukmu",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 18,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																														),
																														Text(
																															"Karya keramik favorit dari pengrajin lokal.",
																															style: TextStyle(
																																color: Color(0xFF1A1A1A),
																																fontSize: 12,
																															),
																														),
																													]
																												),
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(8905),
																											),
																											width: 51,
																											height: 44,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(8905),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ts7k4wc5_expires_30_days.png",
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
																	Positioned(
																		top: 77,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					color: Color(0x00FFFFFF),
																					boxShadow: [
																						BoxShadow(
																							color: Color(0x0D000000),
																							blurRadius: 20,
																							offset: Offset(0, -4),
																						),
																					],
																				),
																				padding: const EdgeInsets.only( top: 13, bottom: 13, left: 23, right: 39),
																				transform: Matrix4.translationValues(5, 0, 0),
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
																													margin: const EdgeInsets.only( top: 26, right: 37),
																													width: double.infinity,
																													child: Stack(
																														clipBehavior: Clip.none,
																														children: [
																															Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Text(
																																		"Beranda",
																																		style: TextStyle(
																																			color: Color(0xFF000000),
																																			fontSize: 11,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																]
																															),
																															Positioned(
																																bottom: 0,
																																left: 3,
																																right: 3,
																																height: 9,
																																child: Container(
																																	height: 9,
																																	width: double.infinity,
																																	child: SizedBox(),
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
																													margin: const EdgeInsets.only( right: 48),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/1dgd2p7b_expires_30_days.png",
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
																													margin: const EdgeInsets.only( right: 41),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ejxv1vs3_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hbtc6hff_expires_30_days.png",
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
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ytxz6wk4_expires_30_days.png",
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