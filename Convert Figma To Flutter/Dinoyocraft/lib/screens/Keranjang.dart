import 'package:flutter/material.dart';
class Keranjang extends StatefulWidget {
	const Keranjang({super.key});
	@override
	KeranjangState createState() => KeranjangState();
}
class KeranjangState extends State<Keranjang> {
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
												topLeft: Radius.circular(32),
												topRight: Radius.circular(32),
											),
											color: Color(0xFFFFFFFF),
											boxShadow: [
												BoxShadow(
													color: Color(0x2E000000),
													blurRadius: 30,
													offset: Offset(0, -8),
												),
											],
										),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											padding: const EdgeInsets.only( bottom: 8),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.symmetric(vertical: 9),
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
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Row(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 8),
																						child: Text(
																							"Keranjang Belanja",
																							style: TextStyle(
																								color: Color(0xFF171717),
																								fontSize: 20,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(9999),
																									color: Color(0xFF171717),
																								),
																								padding: const EdgeInsets.only( top: 1, bottom: 1, left: 10, right: 10),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"2 Produk",
																											style: TextStyle(
																												color: Color(0xFFFFFFFF),
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
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(9999),
																		),
																		width: 36,
																		height: 36,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(9999),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/u9gtzrll_expires_30_days.png",
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
															color: Color(0xCCFAFAFA),
															padding: const EdgeInsets.only( top: 10, bottom: 10, left: 20, right: 20),
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
																							borderRadius: BorderRadius.circular(4),
																						),
																						margin: const EdgeInsets.only( right: 8),
																						width: 18,
																						height: 16,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(4),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xrac59q1_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 11),
																						child: Text(
																							"Pilih Semua",
																							style: TextStyle(
																								color: Color(0xFF171717),
																								fontSize: 12,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Text(
																						"(2 barang)",
																						style: TextStyle(
																							color: Color(0xFFA3A3A3),
																							fontSize: 12,
																						),
																					),
																				]
																			),
																		),
																	),
																	Text(
																		"Hapus Terpilih",
																		style: TextStyle(
																			color: Color(0xFF737373),
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
															padding: const EdgeInsets.only( left: 20, right: 20),
															margin: const EdgeInsets.only( bottom: 15),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.symmetric(vertical: 16),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 12),
																						width: 16,
																						height: 52,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/smc5ba1i_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(16),
																						),
																						margin: const EdgeInsets.only( right: 12),
																						width: 80,
																						height: 80,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(16),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8rj8daxe_expires_30_days.png",
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
																												margin: const EdgeInsets.only( bottom: 4),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Column(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( bottom: 4),
																																			child: Text(
																																				"Ruang Tanah Dinoyo",
																																				style: TextStyle(
																																					color: Color(0xFFA3A3A3),
																																					fontSize: 11,
																																				),
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( right: 24),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Vas Keramik ",
																																								style: TextStyle(
																																									color: Color(0xFF171717),
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
																														Container(
																															width: 23,
																															height: 26,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hrrv3il5_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
																											),
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(6),
																														color: Color(0xFFF5F5F5),
																													),
																													padding: const EdgeInsets.only( top: 1, bottom: 1, left: 8, right: 8),
																													margin: const EdgeInsets.only( bottom: 4),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Broken White Terracotta",
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
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 6),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Rp85.000",
																															style: TextStyle(
																																color: Color(0xFF171717),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(8),
																															),
																															width: 78,
																															height: 30,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(8),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xilbm9q1_expires_30_days.png",
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
																			padding: const EdgeInsets.symmetric(vertical: 17),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 12),
																						width: 16,
																						height: 52,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lob7tc7k_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(16),
																						),
																						margin: const EdgeInsets.only( right: 12),
																						width: 80,
																						height: 80,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(16),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kepyghtd_expires_30_days.png",
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
																												margin: const EdgeInsets.only( bottom: 4),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Column(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( bottom: 3),
																																			child: Text(
																																				"Dinoyo Ceramic Studio",
																																				style: TextStyle(
																																					color: Color(0xFFA3A3A3),
																																					fontSize: 11,
																																				),
																																			),
																																		),
																																		Text(
																																			"Cangkir Handmade ",
																																			style: TextStyle(
																																				color: Color(0xFF171717),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														Container(
																															width: 23,
																															height: 26,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/haerww3h_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																													]
																												),
																											),
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(6),
																														color: Color(0xFFF5F5F5),
																													),
																													padding: const EdgeInsets.only( top: 1, bottom: 1, left: 8, right: 8),
																													margin: const EdgeInsets.only( bottom: 4),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Rustic Speckle Sand",
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
																										IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.symmetric(vertical: 6),
																												width: double.infinity,
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceBetween,
																													children: [
																														Text(
																															"Rp65.000",
																															style: TextStyle(
																																color: Color(0xFF171717),
																																fontSize: 14,
																																fontWeight: FontWeight.bold,
																															),
																														),
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(8),
																															),
																															width: 78,
																															height: 30,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(8),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/86iz4325_expires_30_days.png",
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
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																color: Color(0xFFFFFFFF),
																boxShadow: [
																	BoxShadow(
																		color: Color(0x05000000),
																		blurRadius: 16,
																		offset: Offset(0, -4),
																	),
																],
															),
															padding: const EdgeInsets.only( top: 13, left: 20, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( bottom: 2),
																								child: Column(
																									children: [
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( right: 34),
																													margin: const EdgeInsets.only( bottom: 5),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Total Pembayaran",
																																style: TextStyle(
																																	color: Color(0xFF737373),
																																	fontSize: 12,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																										Text(
																											"Termasuk pajak & asuransi",
																											style: TextStyle(
																												color: Color(0xFFA3A3A3),
																												fontSize: 11,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Text(
																						"Rp215.000",
																						style: TextStyle(
																							color: Color(0xFF171717),
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
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(119),
																				color: Color(0xFF171717),
																			),
																			padding: const EdgeInsets.only( top: 2),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(12),
																									color: Color(0x00FFFFFF),
																									boxShadow: [
																										BoxShadow(
																											color: Color(0x1A171717),
																											blurRadius: 6,
																											offset: Offset(0, 4),
																										),
																									],
																								),
																								padding: const EdgeInsets.symmetric(vertical: 14),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Checkout ",
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
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.center,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 6),
																						width: 10,
																						height: 13,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/2ghf6230_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Text(
																						"Garansi Aman Pecah Belah DinoyoCraft 100%",
																						style: TextStyle(
																							color: Color(0xFF737373),
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