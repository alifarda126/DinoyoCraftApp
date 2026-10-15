import 'package:flutter/material.dart';
class HapusAkun extends StatefulWidget {
	const HapusAkun({super.key});
	@override
	HapusAkunState createState() => HapusAkunState();
}
class HapusAkunState extends State<HapusAkun> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ndzw3kun_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 12),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/9tuuxagy_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Hapus Akun",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/m3qr0q8k_expires_30_days.png",
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
																	color: Color(0x4DBA1A1A),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFDAD6),
															),
															padding: const EdgeInsets.all(17),
															margin: const EdgeInsets.only( bottom: 8, left: 18, right: 18),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 8),
																		width: 32,
																		height: 34,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x6fub41g_expires_30_days.png",
																			fit: BoxFit.fill,
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
																										width: double.infinity,
																										child: Column(
																											crossAxisAlignment: CrossAxisAlignment.start,
																											children: [
																												Container(
																													margin: const EdgeInsets.only( bottom: 4),
																													width: 243,
																													child: Text(
																														"Apakah kamu yakin ingin menghapus\nakun?",
																														style: TextStyle(
																															color: Color(0xFF93000A),
																															fontSize: 14,
																														),
																													),
																												),
																												IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( top: 2),
																														width: double.infinity,
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																IntrinsicHeight(
																																	child: Container(
																																		margin: const EdgeInsets.only( bottom: 2),
																																		width: double.infinity,
																																		child: Stack(
																																			clipBehavior: Clip.none,
																																			children: [
																																				Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						IntrinsicHeight(
																																							child: Container(
																																								padding: const EdgeInsets.only( top: 17),
																																								width: double.infinity,
																																								child: Column(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										Text(
																																											"dibatalkan",
																																											style: TextStyle(
																																												color: Color(0xFF4C4546),
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
																																				Positioned(
																																					top: 0,
																																					left: 0,
																																					width: 113,
																																					height: 20,
																																					child: Container(
																																						transform: Matrix4.translationValues(0, -2, 0),
																																						child: Text(
																																							"Tindakan ini bersifat ",
																																							style: TextStyle(
																																								color: Color(0xFF4C4546),
																																								fontSize: 12,
																																							),
																																						),
																																					),
																																				),
																																				Positioned(
																																					bottom: 0,
																																					right: 0,
																																					width: 180,
																																					height: 20,
																																					child: Container(
																																						transform: Matrix4.translationValues(0, 3, 0),
																																						child: Text(
																																							". Seluruh data profil, riwayat kurasi",
																																							style: TextStyle(
																																								color: Color(0xFF4C4546),
																																								fontSize: 12,
																																							),
																																						),
																																					),
																																				),
																																			]
																																		),
																																	),
																																),
																																Container(
																																	width: 243,
																																	child: Text(
																																		"produk keramik, serta poin DinoyoCraft kamu\nakan dihapus selamanya.",
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
																						Positioned(
																							top: 46,
																							right: 0,
																							width: 154,
																							height: 20,
																							child: Container(
																								transform: Matrix4.translationValues(27, 0, 0),
																								child: Text(
																									"permanen dan tidak dapat",
																									style: TextStyle(
																										color: Color(0xFF4C4546),
																										fontSize: 12,
																										fontWeight: FontWeight.bold,
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
															margin: const EdgeInsets.only( bottom: 20, left: 19, right: 19),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 8),
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
																										"Beri tahu kami alasan kamu (Opsional)",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
																										),
																									),
																								]
																							),
																						),
																					),
																					Container(
																						width: double.infinity,
																						child: Text(
																							"Masukan kamu sangat berharga untuk kemajuan perajin\nkeramik lokal Dinoyo.",
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
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																							),
																							padding: const EdgeInsets.symmetric(vertical: 13),
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
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
																										margin: const EdgeInsets.only( left: 13, right: 8),
																										width: 16,
																										height: 16,
																										child: SizedBox(),
																									),
																									Text(
																										"Sudah jarang membeli keramik",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
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
																							padding: const EdgeInsets.symmetric(vertical: 13),
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
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
																										margin: const EdgeInsets.only( left: 13, right: 8),
																										width: 16,
																										height: 16,
																										child: SizedBox(),
																									),
																									Text(
																										"Ingin membuat akun baru",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
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
																							padding: const EdgeInsets.symmetric(vertical: 13),
																							margin: const EdgeInsets.only( bottom: 8),
																							width: double.infinity,
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
																										margin: const EdgeInsets.only( left: 13, right: 8),
																										width: 16,
																										height: 16,
																										child: SizedBox(),
																									),
																									Text(
																										"Kekhawatiran privasi & keamanan data",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
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
																							padding: const EdgeInsets.symmetric(vertical: 13),
																							width: double.infinity,
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
																										margin: const EdgeInsets.only( left: 13, right: 8),
																										width: 16,
																										height: 16,
																										child: SizedBox(),
																									),
																									Text(
																										"Lainnya",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
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
															margin: const EdgeInsets.only( bottom: 14, left: 19, right: 19),
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
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0xFFFFFFFF),
																			),
																			padding: const EdgeInsets.all(15),
																			margin: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( top: 2),
																								margin: const EdgeInsets.only( right: 8),
																								child: Column(
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												border: Border.all(
																													color: Color(0xFF7E7576),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(4),
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
																										Container(
																											width: 296,
																											child: Text(
																												"Saya mengerti konsekuensi penghapusan akun\nDinoyoCraft ini dan menyatakan bahwa keputusan ini\nbersifat final.",
																												style: TextStyle(
																													color: Color(0xFF000000),
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
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 6),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Masukkan Kata Sandi untuk Konfirmasi",
																										style: TextStyle(
																											color: Color(0xFF000000),
																											fontSize: 14,
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
																							margin: const EdgeInsets.only( bottom: 6),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 17),
																										width: 24,
																										height: 44,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/jvowcyfv_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 12),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Masukkan kata sandi akunmu",
																															style: TextStyle(
																																color: Color(0xFF000000),
																																fontSize: 14,
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Container(
																										width: 28,
																										height: 37,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kucxqyqk_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					Container(
																						width: double.infinity,
																						child: Text(
																							"Verifikasi keamanan untuk memastikan ini benar-benar\npemilik akun.",
																							style: TextStyle(
																								color: Color(0xFF000000),
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
													InkWell(
														onTap: () { print('Pressed'); },
														child: IntrinsicHeight(
															child: Container(
																decoration: BoxDecoration(
																	borderRadius: BorderRadius.circular(64),
																	color: Color(0xFFBA1A1A),
																),
																padding: const EdgeInsets.symmetric(vertical: 12),
																margin: const EdgeInsets.only( bottom: 27, left: 17, right: 17),
																width: double.infinity,
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.center,
																	children: [
																		Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(64),
																			),
																			margin: const EdgeInsets.only( right: 3),
																			width: 12,
																			height: 13,
																			child: ClipRRect(
																				borderRadius: BorderRadius.circular(64),
																				child: Image.network(
																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/fg1xlu2w_expires_30_days.png",
																					fit: BoxFit.fill,
																				)
																			)
																		),
																		Text(
																			"Hapus Akun Secara Permanen",
																			style: TextStyle(
																				color: Color(0xFFFFFFFF),
																				fontSize: 14,
																			),
																		),
																	]
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
						],
					),
				),
			),
		);
	}
}