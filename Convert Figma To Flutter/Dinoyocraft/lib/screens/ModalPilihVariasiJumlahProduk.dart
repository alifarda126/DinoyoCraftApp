import 'package:flutter/material.dart';
class ModalPilihVariasiJumlahProduk extends StatefulWidget {
	const ModalPilihVariasiJumlahProduk({super.key});
	@override
	ModalPilihVariasiJumlahProdukState createState() => ModalPilihVariasiJumlahProdukState();
}
class ModalPilihVariasiJumlahProdukState extends State<ModalPilihVariasiJumlahProduk> {
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
											borderRadius: BorderRadius.only(
												topLeft: Radius.circular(28),
												topRight: Radius.circular(28),
											),
											color: Color(0xFFFFFFFF),
											boxShadow: [
												BoxShadow(
													color: Color(0x40000000),
													blurRadius: 40,
													offset: Offset(0, -12),
												),
											],
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
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(9999),
																			color: Color(0xFFD4D4D4),
																		),
																		width: 48,
																		height: 6,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.all(20),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(16),
																		),
																		margin: const EdgeInsets.only( right: 16),
																		width: 80,
																		height: 80,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(16),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/bkqukygo_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Stack(
																					clipBehavior: Clip.none,
																					children: [
																						Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								IntrinsicHeight(
																									child: Container(
																										padding: const EdgeInsets.only( right: 24),
																										width: double.infinity,
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 1),
																													child: Text(
																														"Dinoyo Ceramic Studio",
																														style: TextStyle(
																															color: Color(0xFF737373),
																															fontSize: 12,
																														),
																													),
																												),
																												IntrinsicHeight(
																													child: Container(
																														margin: const EdgeInsets.only( bottom: 1),
																														width: double.infinity,
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"Vas Keramik Minimalis",
																																	style: TextStyle(
																																		color: Color(0xFF000000),
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
																														padding: const EdgeInsets.symmetric(vertical: 2),
																														margin: const EdgeInsets.only( bottom: 2),
																														width: double.infinity,
																														child: Row(
																															children: [
																																Container(
																																	margin: const EdgeInsets.only( right: 10),
																																	child: Text(
																																		"Rp85.000",
																																		style: TextStyle(
																																			color: Color(0xFF000000),
																																			fontSize: 18,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																),
																																Text(
																																	"Rp110.000",
																																	style: TextStyle(
																																		color: Color(0xFFA3A3A3),
																																		fontSize: 11,
																																		decoration: TextDecoration.lineThrough,
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
																																Container(
																																	margin: const EdgeInsets.only( right: 6),
																																	child: Text(
																																		"Stok Pengrajin:",
																																		style: TextStyle(
																																			color: Color(0xFF737373),
																																			fontSize: 12,
																																		),
																																	),
																																),
																																Text(
																																	"18 buah",
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
																											]
																										),
																									),
																								),
																							]
																						),
																						Positioned(
																							top: 0,
																							right: 0,
																							width: 32,
																							height: 32,
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(9999),
																								),
																								transform: Matrix4.translationValues(4, -20, 0),
																								width: 32,
																								height: 32,
																								child: ClipRRect(
																									borderRadius: BorderRadius.circular(9999),
																									child: Image.network(
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qusaxr16_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
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
															padding: const EdgeInsets.all(20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 20),
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
																										"PILIHAN WARNA / GLAZE",
																										style: TextStyle(
																											color: Color(0xFF262626),
																											fontSize: 12,
																											fontWeight: FontWeight.bold,
																										),
																									),
																									Text(
																										"Sand White Glossy",
																										style: TextStyle(
																											color: Color(0xFF737373),
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
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 10),
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
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFFAFAFA),
																																),
																																padding: const EdgeInsets.symmetric(vertical: 12),
																																margin: const EdgeInsets.only( right: 11),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(9999),
																																			),
																																			margin: const EdgeInsets.only( left: 12, right: 10),
																																			width: 24,
																																			height: 24,
																																			child: ClipRRect(
																																				borderRadius: BorderRadius.circular(9999),
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/an9hgb87_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			)
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Sand White",
																																							style: TextStyle(
																																								color: Color(0xFF000000),
																																								fontSize: 12,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						Text(
																																							"Glossy Finish",
																																							style: TextStyle(
																																								color: Color(0xFF737373),
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
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																decoration: BoxDecoration(
																																	border: Border.all(
																																		color: Color(0xFFE5E5E5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFFFFFFF),
																																),
																																padding: const EdgeInsets.symmetric(vertical: 12),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFFD4D4D4),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(9999),
																																				color: Color(0xFFC97A5B),
																																				boxShadow: [
																																					BoxShadow(
																																						color: Color(0x0D000000),
																																						blurRadius: 4,
																																						offset: Offset(0, 2),
																																					),
																																				],
																																			),
																																			margin: const EdgeInsets.only( left: 11, right: 10),
																																			width: 24,
																																			height: 24,
																																			child: SizedBox(),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Terracotta",
																																							style: TextStyle(
																																								color: Color(0xFF262626),
																																								fontSize: 12,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						Text(
																																							"Matte Earthy",
																																							style: TextStyle(
																																								color: Color(0xFF737373),
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
																																decoration: BoxDecoration(
																																	border: Border.all(
																																		color: Color(0xFFE5E5E5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFFFFFFF),
																																),
																																padding: const EdgeInsets.symmetric(vertical: 11),
																																margin: const EdgeInsets.only( right: 11),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFFD4D4D4),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(9999),
																																				color: Color(0xFFD9D5CD),
																																				boxShadow: [
																																					BoxShadow(
																																						color: Color(0x0D000000),
																																						blurRadius: 4,
																																						offset: Offset(0, 2),
																																					),
																																				],
																																			),
																																			margin: const EdgeInsets.only( left: 11, right: 10),
																																			width: 24,
																																			height: 24,
																																			child: SizedBox(),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Raw Speckle",
																																							style: TextStyle(
																																								color: Color(0xFF262626),
																																								fontSize: 12,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									padding: const EdgeInsets.only( right: 22),
																																									child: Column(
																																										crossAxisAlignment: CrossAxisAlignment.start,
																																										children: [
																																											Text(
																																												"Bintik Alami",
																																												style: TextStyle(
																																													color: Color(0xFF737373),
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
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																decoration: BoxDecoration(
																																	border: Border.all(
																																		color: Color(0xFFE5E5E5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFFFFFFF),
																																),
																																padding: const EdgeInsets.symmetric(vertical: 11),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFFD4D4D4),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(9999),
																																				color: Color(0xFF3F3F3F),
																																				boxShadow: [
																																					BoxShadow(
																																						color: Color(0x0D000000),
																																						blurRadius: 4,
																																						offset: Offset(0, 2),
																																					),
																																				],
																																			),
																																			margin: const EdgeInsets.only( left: 11, right: 10),
																																			width: 24,
																																			height: 24,
																																			child: SizedBox(),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Column(
																																					children: [
																																						Text(
																																							"Charcoal Ash",
																																							style: TextStyle(
																																								color: Color(0xFF262626),
																																								fontSize: 12,
																																								fontWeight: FontWeight.bold,
																																							),
																																						),
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									padding: const EdgeInsets.only( right: 22),
																																									child: Column(
																																										crossAxisAlignment: CrossAxisAlignment.start,
																																										children: [
																																											Text(
																																												"Tekstur Abu",
																																												style: TextStyle(
																																													color: Color(0xFF737373),
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
																			padding: const EdgeInsets.symmetric(vertical: 5),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 20),
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"JUMLAH PRODUK",
																											style: TextStyle(
																												color: Color(0xFF262626),
																												fontSize: 12,
																												fontWeight: FontWeight.bold,
																											),
																										),
																										Text(
																											"Maks. 5 buah per checkout khusus keramik",
																											style: TextStyle(
																												color: Color(0xFF737373),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						width: 114,
																						height: 42,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/g79mcymq_expires_30_days.png",
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.all(16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 4, right: 4),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"Subtotal Estimasi:",
																						style: TextStyle(
																							color: Color(0xFF737373),
																							fontSize: 12,
																						),
																					),
																					Text(
																						"Rp85.000",
																						style: TextStyle(
																							color: Color(0xFF000000),
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
																					color: Color(0xFF000000),
																					width: 2,
																				),
																				borderRadius: BorderRadius.circular(61),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.symmetric(vertical: 16),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.center,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 6),
																								child: Stack(
																									clipBehavior: Clip.none,
																									children: [
																										Padding(
																											padding: const EdgeInsets.all(1),
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														width: 12,
																														height: 11,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/d6wj09d5_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																												]
																											),
																										),
																										Positioned(
																											top: 1,
																											left: 6,
																											right: 6,
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