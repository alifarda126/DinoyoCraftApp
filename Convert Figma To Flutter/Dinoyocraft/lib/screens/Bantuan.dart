import 'package:flutter/material.dart';
class Bantuan extends StatefulWidget {
	const Bantuan({super.key});
	@override
	BantuanState createState() => BantuanState();
}
class BantuanState extends State<Bantuan> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/aclouulw_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 24),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pd1wj26i_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Bantuan",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xpopj47d_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 11, left: 20, right: 20),
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
																							margin: const EdgeInsets.only( bottom: 16),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 4),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Text(
																														"Butuh Bantuan?",
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
																											"Temukan jawaban untuk pertanyaan seputar\nDinoyoCraft.",
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
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 11),
																										width: 30,
																										height: 48,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qsichro4_expires_30_days.png",
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
																															"Cari pertanyaan...",
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
																							margin: const EdgeInsets.only( bottom: 12),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Pertanyaan Umum",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
																											fontSize: 18,
																											fontWeight: FontWeight.bold,
																										),
																									),
																									Text(
																										"6 Pertanyaan",
																										style: TextStyle(
																											color: Color(0xFF1A1A1A),
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
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Bagaimana cara memesan produk?",
																														style: TextStyle(
																															color: Color(0xFF1A1A1A),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/oq8khxhk_expires_30_days.png",
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
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 18),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Bagaimana cara melakukan pembayaran?",
																																			style: TextStyle(
																																				color: Color(0xFF1A1A1A),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/0j7vt5w3_expires_30_days.png",
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
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Berapa lama proses pengiriman?",
																														style: TextStyle(
																															color: Color(0xFF1A1A1A),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rhkk2ifa_expires_30_days.png",
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
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Apakah produk bisa diretur?",
																														style: TextStyle(
																															color: Color(0xFF1A1A1A),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/6h6a70lp_expires_30_days.png",
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
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											margin: const EdgeInsets.only( bottom: 10),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 48),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Bagaimana cara reservasi workshop?",
																																			style: TextStyle(
																																				color: Color(0xFF1A1A1A),
																																				fontSize: 14,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/bn6fri5l_expires_30_days.png",
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
																												border: Border.all(
																													color: Color(0xFFCCCCCC),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 15, bottom: 15, left: 17, right: 17),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Dimana lokasi toko DinoyoCraft?",
																														style: TextStyle(
																															color: Color(0xFF1A1A1A),
																															fontSize: 14,
																															fontWeight: FontWeight.bold,
																														),
																													),
																													Container(
																														width: 16,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zf16wfdt_expires_30_days.png",
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
																				]
																			),
																		),
																	),
																	Container(
																		margin: const EdgeInsets.only( bottom: 24),
																		height: 1,
																		width: double.infinity,
																		child: SizedBox(),
																	),
																	IntrinsicHeight(
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
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Masih Butuh Bantuan?",
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
																					IntrinsicHeight(
																						child: Container(
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Jika belum menemukan jawaban yang kamu cari,\nhubungi contact person DinoyoCraft melalui WhatsApp.",
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
																]
															),
														),
													),
													Container(
														decoration: BoxDecoration(
															border: Border.all(
																color: Color(0xFFCCCCCC),
																width: 1,
															),
															borderRadius: BorderRadius.circular(16),
															color: Color(0xFFF5F5F5),
														),
														margin: const EdgeInsets.symmetric(horizontal: 20),
														height: 14,
														width: double.infinity,
														child: SizedBox(),
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