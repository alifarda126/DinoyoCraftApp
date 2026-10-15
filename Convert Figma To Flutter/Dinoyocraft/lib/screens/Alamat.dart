import 'package:flutter/material.dart';
class Alamat extends StatefulWidget {
	const Alamat({super.key});
	@override
	AlamatState createState() => AlamatState();
}
class AlamatState extends State<Alamat> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/n3ii8ect_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 14),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/67jgq4tx_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Kelola Alamat",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/75hqgjre_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 17, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Text(
																		"Alamat Pengiriman Terdaftar",
																		style: TextStyle(
																			color: Color(0xFF5F5E5E),
																			fontSize: 12,
																		),
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					border: Border.all(
																						color: Color(0x66CFC4C5),
																						width: 1,
																					),
																					borderRadius: BorderRadius.circular(9999),
																					color: Color(0xFFFFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"3 dari 5 alamat",
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
																borderRadius: BorderRadius.circular(16),
																color: Color(0xFFFFFFFF),
																boxShadow: [
																	BoxShadow(
																		color: Color(0x0D000000),
																		blurRadius: 2,
																		offset: Offset(0, 1),
																	),
																],
															),
															padding: const EdgeInsets.all(18),
															margin: const EdgeInsets.only( bottom: 16, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 11),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Row(
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(9999),
																													color: Color(0xFF000000),
																												),
																												padding: const EdgeInsets.only( top: 4, bottom: 4, left: 10, right: 10),
																												margin: const EdgeInsets.only( right: 6),
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(9999),
																															),
																															margin: const EdgeInsets.only( right: 4),
																															width: 12,
																															height: 12,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(9999),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/e1dh1kms_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														Text(
																															"Utama",
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
																									IntrinsicWidth(
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
																												padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"Rumah",
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
																								]
																							),
																						),
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(9999),
																						),
																						width: 24,
																						height: 24,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(9999),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/t4eifgr3_expires_30_days.png",
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
																			padding: const EdgeInsets.only( top: 1),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 2),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Mochammad Al Mizan",
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
																									Text(
																										"+62 812-3456-7890",
																										style: TextStyle(
																											color: Color(0xFF5F5E5E),
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
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 10),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						width: double.infinity,
																						child: Text(
																							"Jl. Raya Sukun No. 128, RT 03 / RW 02, Sukun Raya, Kec. Sukun, Kota Malang, Jawa Timur\n65144",
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
																			decoration: BoxDecoration(
																				border: Border.all(
																					color: Color(0x66CFC4C5),
																					width: 1,
																				),
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0xFFF4F3F3),
																			),
																			padding: const EdgeInsets.only( top: 16, bottom: 16, left: 13, right: 13),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(12),
																						),
																						margin: const EdgeInsets.only( right: 10),
																						width: 16,
																						height: 14,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(12),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/qywcetem_expires_30_days.png",
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
																															"Catatan untuk kurir:",
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
																																"\"Pagar hitam depan studio keramik, titip ke\nsatpam jika tidak ada di tempat.\"",
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
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( top: 27, right: 23),
																								width: double.infinity,
																								child: Row(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 4),
																											width: 10,
																											height: 13,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/p7otlt79_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																										Container(
																											width: 69,
																											child: Text(
																												"Titik Peta\nTerverifikasi",
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
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( top: 16),
																								width: double.infinity,
																								child: Row(
																									children: [
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xB0000000),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(8),
																													),
																													padding: const EdgeInsets.symmetric(vertical: 7),
																													margin: const EdgeInsets.only( right: 6),
																													width: double.infinity,
																													child: Row(
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(8),
																																),
																																margin: const EdgeInsets.only( left: 15, right: 21),
																																width: 12,
																																height: 12,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(8),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/z70ub93s_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Container(
																																width: 47,
																																child: Text(
																																	"Ubah\nAlamat",
																																	style: TextStyle(
																																		color: Color(0xFF1A1C1C),
																																		fontSize: 14,
																																	),
																																	textAlign: TextAlign.center,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(8),
																											),
																											width: 31,
																											height: 32,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(8),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/da6uc39e_expires_30_days.png",
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
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 48, left: 16, right: 16),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					decoration: BoxDecoration(
																						border: Border.all(
																							color: Color(0xB0CFC4C5),
																							width: 1,
																						),
																						borderRadius: BorderRadius.circular(16),
																						color: Color(0xFFFFFFFF),
																						boxShadow: [
																							BoxShadow(
																								color: Color(0x0D000000),
																								blurRadius: 2,
																								offset: Offset(0, 1),
																							),
																						],
																					),
																					padding: const EdgeInsets.all(17),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 11),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
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
																															color: Color(0xFFFAF9F9),
																														),
																														padding: const EdgeInsets.only( top: 2, bottom: 2, left: 11, right: 11),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"Kantor",
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
																										]
																									),
																								),
																							),
																							IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( top: 1),
																									margin: const EdgeInsets.only( bottom: 12),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( bottom: 1),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Mochammad Al Mizan (Kantor)",
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
																															Text(
																																"+62 812-9876-5432",
																																style: TextStyle(
																																	color: Color(0xFF5F5E5E),
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
																							IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 10),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Container(
																												width: double.infinity,
																												child: Text(
																													"Kantor Google, Jl. Mayjen Haryono No. 9,\nDinoyo, Lowokwaru, Kota Malang, Jawa Timur\n65145",
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
																									padding: const EdgeInsets.only( top: 16),
																									width: double.infinity,
																									child: Row(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Expanded(
																												child: Container(
																													margin: const EdgeInsets.only( right: 32),
																													width: double.infinity,
																													child: Text(
																														"Jadikan Alamat Utama",
																														style: TextStyle(
																															color: Color(0xFF000000),
																															fontSize: 12,
																															decoration: TextDecoration.underline,
																														),
																														textAlign: TextAlign.center,
																													),
																												),
																											),
																											Expanded(
																												child: IntrinsicHeight(
																													child: Container(
																														width: double.infinity,
																														child: Row(
																															children: [
																																InkWell(
																																	onTap: () { print('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xB0000000),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(8),
																																				),
																																				padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																				margin: const EdgeInsets.only( right: 7),
																																				child: Row(
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(8),
																																							),
																																							margin: const EdgeInsets.only( right: 4),
																																							width: 12,
																																							height: 12,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(8),
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xp8b0nfh_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																						Text(
																																							"Ubah",
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
																																),
																																InkWell(
																																	onTap: () { print('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xB0000000),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(8),
																																				),
																																				padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																				child: Row(
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(8),
																																							),
																																							margin: const EdgeInsets.only( right: 4),
																																							width: 10,
																																							height: 12,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(8),
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8ssllylv_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																						Text(
																																							"Hapus",
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
																	Positioned(
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.only(
																						bottomRight: Radius.circular(25),
																						bottomLeft: Radius.circular(25),
																					),
																					color: Color(0x80FFFFFF),
																				),
																				padding: const EdgeInsets.symmetric(vertical: 13),
																				transform: Matrix4.translationValues(16, 74, 0),
																				width: double.infinity,
																				child: Column(
																					children: [
																						InkWell(
																							onTap: () { print('Pressed'); },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(109),
																										color: Color(0xFF000000),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x0D000000),
																												blurRadius: 2,
																												offset: Offset(0, 1),
																											),
																										],
																									),
																									padding: const EdgeInsets.symmetric(vertical: 14),
																									margin: const EdgeInsets.only( bottom: 10, left: 16, right: 16),
																									width: double.infinity,
																									child: Row(
																										mainAxisAlignment: MainAxisAlignment.center,
																										children: [
																											Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(109),
																												),
																												margin: const EdgeInsets.only( right: 8),
																												width: 11,
																												height: 11,
																												child: ClipRRect(
																													borderRadius: BorderRadius.circular(109),
																													child: Image.network(
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/r6fp7ic0_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												)
																											),
																											Text(
																												"Tambah Alamat Baru",
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
																						Text(
																							"Maksimal 5 alamat tersimpan untuk kemudahan checkout.",
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