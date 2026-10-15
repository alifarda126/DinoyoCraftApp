import 'package:flutter/material.dart';
class Notif extends StatefulWidget {
	const Notif({super.key});
	@override
	NotifState createState() => NotifState();
}
class NotifState extends State<Notif> {
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
												topLeft: Radius.circular(24),
												topRight: Radius.circular(24),
											),
											color: Color(0xFFFFFFFF),
											boxShadow: [
												BoxShadow(
													color: Color(0x40000000),
													blurRadius: 50,
													offset: Offset(0, 25),
												),
											],
										),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.symmetric(vertical: 17),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(9999),
																			color: Color(0xFFCFC4C5),
																		),
																		margin: const EdgeInsets.only( bottom: 4),
																		width: 40,
																		height: 6,
																		child: SizedBox(),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 25, left: 20, right: 20),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 10),
																										child: Text(
																											"Notifikasi",
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
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFF000000),
																												),
																												padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"3 Baru",
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
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Row(
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(8),
																										),
																										margin: const EdgeInsets.only( right: 6),
																										width: 52,
																										height: 40,
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zfyq27b0_expires_30_days.png",
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
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( bottom: 8, left: 38, right: 38),
																				width: double.infinity,
																				child: Row(
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
																										padding: const EdgeInsets.only( top: 6, bottom: 6, left: 14, right: 14),
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
																												color: Color(0xFFCFC4C5),
																												width: 1,
																											),
																											borderRadius: BorderRadius.circular(9999),
																											color: Color(0xFFF4F3F3),
																										),
																										padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																										margin: const EdgeInsets.only( right: 9),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Text(
																													"Transaksi & Pesanan",
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
																											color: Color(0xFFF4F3F3),
																										),
																										padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Text(
																													"Info Akun",
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
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.symmetric(horizontal: 20),
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
																								borderRadius: BorderRadius.circular(16),
																								color: Color(0xB0F4F3F3),
																							),
																							padding: const EdgeInsets.all(13),
																							margin: const EdgeInsets.only( bottom: 12),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																										),
																										margin: const EdgeInsets.only( right: 14),
																										width: 44,
																										height: 44,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(12),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/yvubpsly_expires_30_days.png",
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
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Row(
																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																	children: [
																																		Text(
																																			"DISKON PENGRAJIN",
																																			style: TextStyle(
																																				color: Color(0xFF5F5E5E),
																																				fontSize: 11,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Row(
																																					children: [
																																						Container(
																																							margin: const EdgeInsets.only( right: 7),
																																							child: Text(
																																								"2 jam lalu",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						),
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
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Voucher Diskon Keramik 15%",
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
																																padding: const EdgeInsets.only( right: 25),
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Gunakan kode ",
																																			style: TextStyle(
																																				color: Color(0xFF4C4546),
																																				fontSize: 12,
																																			),
																																		),
																																		IntrinsicHeight(
																																			child: Container(
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.end,
																																					children: [
																																						Container(
																																							margin: const EdgeInsets.only( right: 31),
																																							child: Text(
																																								" untuk",
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
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					decoration: BoxDecoration(
																																						border: Border.all(
																																							color: Color(0xFFCFC4C5),
																																							width: 1,
																																						),
																																						borderRadius: BorderRadius.circular(4),
																																						color: Color(0xFFEEEEEE),
																																					),
																																					padding: const EdgeInsets.only( top: 1, bottom: 1, left: 7, right: 7),
																																					margin: const EdgeInsets.only( left: 86),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"DINOYOKARYA",
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
																																		Container(
																																			width: 243,
																																			child: Text(
																																				"potongan belanja produk tembikar buatan\npengrajin Dinoyo.",
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
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 7),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( right: 4),
																																			child: Text(
																																				"Salin Voucher",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 12,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		),
																																		Container(
																																			width: 9,
																																			height: 11,
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lvvx2pw8_expires_30_days.png",
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
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFF000000),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(16),
																								color: Color(0xB0F4F3F3),
																							),
																							padding: const EdgeInsets.all(13),
																							margin: const EdgeInsets.only( bottom: 12),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																										),
																										margin: const EdgeInsets.only( right: 14),
																										width: 44,
																										height: 44,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(12),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cw5ghwet_expires_30_days.png",
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
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Row(
																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																	children: [
																																		Text(
																																			"WISATA KREATIF",
																																			style: TextStyle(
																																				color: Color(0xFF5F5E5E),
																																				fontSize: 11,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Row(
																																					children: [
																																						Container(
																																							margin: const EdgeInsets.only( right: 7),
																																							child: Text(
																																								"Kemarin, 14:20",
																																								style: TextStyle(
																																									color: Color(0xFF5F5E5E),
																																									fontSize: 12,
																																								),
																																							),
																																						),
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
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( right: 11),
																																margin: const EdgeInsets.only( bottom: 2),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			width: double.infinity,
																																			child: Text(
																																				"Jadwal Workshop Pembuatan Keramik",
																																				style: TextStyle(
																																					color: Color(0xFF1A1C1C),
																																					fontSize: 14,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 1),
																																margin: const EdgeInsets.only( bottom: 2),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			width: double.infinity,
																																			child: Text(
																																				"Kelas seni putar tanah liat akhir pekan ini di\nStudio Dinoyo dibuka. Kuota tersisa 3 orang!",
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
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 7),
																																width: double.infinity,
																																child: Row(
																																	children: [
																																		Container(
																																			margin: const EdgeInsets.only( right: 4),
																																			child: Text(
																																				"Lihat Detail Workshop",
																																				style: TextStyle(
																																					color: Color(0xFF000000),
																																					fontSize: 12,
																																					fontWeight: FontWeight.bold,
																																				),
																																			),
																																		),
																																		Container(
																																			width: 9,
																																			height: 9,
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/645sj1gw_expires_30_days.png",
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
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFEEEEEE),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(16),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.all(13),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																										),
																										margin: const EdgeInsets.only( right: 14),
																										width: 44,
																										height: 44,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(12),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/51g08yrp_expires_30_days.png",
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
																																margin: const EdgeInsets.only( bottom: 3),
																																width: double.infinity,
																																child: Row(
																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																	children: [
																																		Text(
																																			"PEMBAYARAN",
																																			style: TextStyle(
																																				color: Color(0xFF5F5E5E),
																																				fontSize: 11,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																		Text(
																																			"2 hari lalu",
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
																																margin: const EdgeInsets.only( bottom: 2),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Pembayaran Dikonfirmasi",
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
																																padding: const EdgeInsets.only( top: 1),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Container(
																																			width: double.infinity,
																																			child: Text(
																																				"Pembayaran via GoPay untuk pesanan Cangkir\nSpeckle sebesar Rp70.000 telah berhasil\ndiverifikasi.",
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