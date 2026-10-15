import 'package:flutter/material.dart';
class Pengaturan extends StatefulWidget {
	const Pengaturan({super.key});
	@override
	PengaturanState createState() => PengaturanState();
}
class PengaturanState extends State<Pengaturan> {
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
											padding: const EdgeInsets.symmetric(vertical: 12),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ljpgyld2_expires_30_days.png",
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/29nrlywq_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Kelola Pengaturan",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/14qfs9on_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 20, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 4, right: 4),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"AKUN & KEAMANAN",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 12,
																						),
																					),
																					Container(
																						width: 10,
																						height: 14,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cs1v8lhi_expires_30_days.png",
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
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x03000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.all(1),
																			margin: const EdgeInsets.only( top: 8),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.all(16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/6stlj3eb_expires_30_days.png",
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
																																			child: Container(
																																				padding: const EdgeInsets.only( right: 47),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Ubah Kata Sandi",
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
																																	Text(
																																		"Terakhir diubah 3 bulan lalu",
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
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/55ger01u_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 41),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( right: 12),
																															width: 36,
																															height: 36,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/zcfa1m7v_expires_30_days.png",
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
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Autentikasi 2 Langkah (2FA)",
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
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Container(
																																								width: 174,
																																								child: Text(
																																									"Tingkatkan keamanan akun via\nSMS/OTP",
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
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFF000000),
																												),
																												padding: const EdgeInsets.only( top: 2, bottom: 2, left: 22, right: 2),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																border: Border.all(
																																	color: Color(0xFFFFFFFF),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(9999),
																																color: Color(0xFFFFFFFF),
																															),
																															width: 20,
																															height: 20,
																															child: SizedBox(),
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
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/4qweggp5_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Column(
																																children: [
																																	Text(
																																		"Perangkat Terhubung",
																																		style: TextStyle(
																																			color: Color(0xFF1A1C1C),
																																			fontSize: 14,
																																		),
																																	),
																																	Text(
																																		"1 perangkat aktif saat ini",
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
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/bgqmhuag_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/c60jedqt_expires_30_days.png",
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
																																			child: Container(
																																				padding: const EdgeInsets.only( right: 128),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Hapus Akun",
																																							style: TextStyle(
																																								color: Color(0xFFBA1A1A),
																																								fontSize: 14,
																																							),
																																						),
																																					]
																																				),
																																			),
																																		),
																																	),
																																	Text(
																																		"Nonaktifkan akun secara permanen",
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
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/97fuw4di_expires_30_days.png",
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
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 20, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 4, right: 4),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"NOTIFIKASI",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 12,
																						),
																					),
																					Container(
																						width: 10,
																						height: 13,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/p6vk7zrb_expires_30_days.png",
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
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x03000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.all(1),
																			margin: const EdgeInsets.only( top: 8),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.all(16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 23),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( right: 12),
																															width: 36,
																															height: 36,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/19lt02dl_expires_30_days.png",
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
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Status Pesanan & Pengiriman",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																			Container(
																																				width: 200,
																																				child: Text(
																																					"Update resi pengiriman tembikar &\nkeramik",
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
																									),
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFF000000),
																												),
																												padding: const EdgeInsets.only( top: 2, bottom: 2, left: 22, right: 2),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																border: Border.all(
																																	color: Color(0xFFFFFFFF),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(9999),
																																color: Color(0xFFFFFFFF),
																															),
																															width: 20,
																															height: 20,
																															child: SizedBox(),
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
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 20),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( right: 12),
																															width: 36,
																															height: 36,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/yt1z7qk0_expires_30_days.png",
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
																																					width: double.infinity,
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Notifikasi via WhatsApp",
																																								style: TextStyle(
																																									color: Color(0xFF1A1C1C),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																			Container(
																																				width: 203,
																																				child: Text(
																																					"Terima nota dan update pengiriman\nvia WA",
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
																									),
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFF000000),
																												),
																												padding: const EdgeInsets.only( top: 2, bottom: 2, left: 22, right: 2),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																border: Border.all(
																																	color: Color(0xFFFFFFFF),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(9999),
																																color: Color(0xFFFFFFFF),
																															),
																															width: 20,
																															height: 20,
																															child: SizedBox(),
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
															margin: const EdgeInsets.only( bottom: 20, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 4, right: 4),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"PREFERENSI APLIKASI",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 12,
																						),
																					),
																					Container(
																						width: 12,
																						height: 12,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wrb6dtfb_expires_30_days.png",
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
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x03000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.all(1),
																			margin: const EdgeInsets.only( top: 8),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.all(16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/y2xojquw_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Column(
																																children: [
																																	Text(
																																		"Bahasa Aplikasi",
																																		style: TextStyle(
																																			color: Color(0xFF1A1C1C),
																																			fontSize: 14,
																																		),
																																	),
																																	Text(
																																		"Bahasa Indonesia",
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
																																padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																																margin: const EdgeInsets.only( right: 6),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"ID",
																																			style: TextStyle(
																																				color: Color(0xFF1A1C1C),
																																				fontSize: 11,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Container(
																														width: 6,
																														height: 10,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/24qbsmkc_expires_30_days.png",
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
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a48nwkvr_expires_30_days.png",
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
																																			child: Container(
																																				padding: const EdgeInsets.only( right: 18),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Tema Tampilan",
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
																																	Text(
																																		"Terang (Light Mode)",
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
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/scs4kvhi_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kjh1t9n3_expires_30_days.png",
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
																																			child: Container(
																																				padding: const EdgeInsets.only( right: 21),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Bersihkan Cache",
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
																																	Text(
																																		"24.5 MB file sementara",
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
																														color: Color(0xFFFAF9F9),
																													),
																													padding: const EdgeInsets.only( top: 7, bottom: 7, left: 15, right: 15),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Bersihkan",
																																style: TextStyle(
																																	color: Color(0xFF1A1C1C),
																																	fontSize: 11,
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
															margin: const EdgeInsets.only( bottom: 19, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( left: 4, right: 4),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"PRIVASI & LEGALITAS",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 12,
																						),
																					),
																					Container(
																						width: 10,
																						height: 13,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/0rd5ocqg_expires_30_days.png",
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
																					color: Color(0xFFCFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(16),
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x03000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.all(1),
																			margin: const EdgeInsets.only( top: 8),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.all(16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gxm2qt72_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Text(
																														"Kebijakan Privasi",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																														),
																													),
																												]
																											),
																										),
																									),
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/y5gwmtk6_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
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
																															borderRadius: BorderRadius.circular(12),
																														),
																														margin: const EdgeInsets.only( right: 12),
																														width: 36,
																														height: 36,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(12),
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gpuw16w7_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																													Text(
																														"Syarat & Ketentuan Penggunaan",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 14,
																														),
																													),
																												]
																											),
																										),
																									),
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/blz8qe71_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 8),
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															margin: const EdgeInsets.only( right: 12),
																															width: 36,
																															height: 36,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/eds8kzkl_expires_30_days.png",
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
																																				"Kebijakan Garansi Barang Pecah Belah",
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
																													]
																												),
																											),
																										),
																									),
																									Container(
																										width: 6,
																										height: 10,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/kc9b3mp8_expires_30_days.png",
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
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12),
															margin: const EdgeInsets.symmetric(horizontal: 16),
															width: double.infinity,
															child: Column(
																children: [
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					border: Border.all(
																						color: Color(0xFFFF0000),
																						width: 1,
																					),
																					borderRadius: BorderRadius.circular(30),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.symmetric(vertical: 14),
																				width: double.infinity,
																				child: Row(
																					mainAxisAlignment: MainAxisAlignment.center,
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(30),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 15,
																							height: 15,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(30),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/u7nu2h14_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Text(
																							"Keluar dari Akun",
																							style: TextStyle(
																								color: Color(0xFFFF0000),
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
																				padding: const EdgeInsets.only( top: 16),
																				child: Column(
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.symmetric(vertical: 8),
																									child: Column(
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( left: 44, right: 44),
																														margin: const EdgeInsets.only( bottom: 1),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"DinoyoCraft App v1.0.4",
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
																												"Sentra Keramik Dinoyo Malang • Jawa Timur",
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