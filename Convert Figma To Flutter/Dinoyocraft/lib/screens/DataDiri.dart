import 'package:flutter/material.dart';
class DataDiri extends StatefulWidget {
	const DataDiri({super.key});
	@override
	DataDiriState createState() => DataDiriState();
}
class DataDiriState extends State<DataDiri> {
	String textField1 = '';
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
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 8),
															width: double.infinity,
															child: Column(
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
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5c07lsni_expires_30_days.png",
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
																			margin: const EdgeInsets.only( bottom: 20),
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
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/dc19hrj9_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										)
																									),
																									Text(
																										"Kelola Data Diri",
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
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ir7rg8s2_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24, left: 16, right: 16),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 26),
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
																															"Ubah Data Diri",
																															style: TextStyle(
																																color: Color(0xFF1A1C1C),
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
																														Text(
																															"Kelola informasi akun dan profil pengrajin Anda",
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
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									border: Border.all(
																										color: Color(0x99CFC4C5),
																										width: 1,
																									),
																									borderRadius: BorderRadius.circular(4),
																									color: Color(0xFFFFFFFF),
																								),
																								padding: const EdgeInsets.only( top: 5, bottom: 5, left: 9, right: 9),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"ID #8821",
																											style: TextStyle(
																												color: Color(0xFF5F5E5E),
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
																			child: Container(
																				margin: const EdgeInsets.only( bottom: 24),
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 8),
																							width: 96,
																							height: 96,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cqwdk0yx_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Container(
																							margin: const EdgeInsets.only( bottom: 2),
																							child: Text(
																								"Ubah Foto Profil",
																								style: TextStyle(
																									color: Color(0xFF000000),
																									fontSize: 12,
																								),
																							),
																						),
																						Text(
																							"Format JPG, PNG atau WEBP. Maksimal 5 MB.",
																							style: TextStyle(
																								color: Color(0xFF5F5E5E),
																								fontSize: 11,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 10, left: 16, right: 16),
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
																											margin: const EdgeInsets.only( bottom: 6),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Nama Lengkap",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 12,
																														),
																													),
																													Text(
																														"Sesuai KTP",
																														style: TextStyle(
																															color: Color(0xFF5F5E5E),
																															fontSize: 11,
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
																													color: Color(0xCCCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 13, bottom: 13, left: 15, right: 15),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 12),
																														width: 13,
																														height: 13,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xckxq1e7_expires_30_days.png",
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
																																			"Mochammad Al Mizan Ya Hafidl",
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
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 16),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 5),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												children: [
																													Text(
																														"Username",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 12,
																														),
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																decoration: BoxDecoration(
																																	border: Border.all(
																																		color: Color(0x80CFC4C5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(4),
																																	color: Color(0xFFEEEEEE),
																																),
																																padding: const EdgeInsets.only( top: 3, bottom: 3, left: 7, right: 7),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Tersedia",
																																			style: TextStyle(
																																				color: Color(0xFF474746),
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
																													color: Color(0xCCCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 12, bottom: 12, left: 14, right: 14),
																											margin: const EdgeInsets.only( bottom: 6),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 8),
																														child: Text(
																															"@",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 14,
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
																																			"mizanyf",
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
																									IntrinsicHeight(
																										child: Container(
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 4),
																														width: 10,
																														height: 10,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8ug59vcv_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Container(
																														width: 302,
																														child: Text(
																															"Username profil dinoyocraft.id/@mizanyf. Ubah 30 hari\nsekali.",
																															style: TextStyle(
																																color: Color(0xFF5F5E5E),
																																fontSize: 11,
																																fontWeight: FontWeight.bold,
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
																							margin: const EdgeInsets.only( bottom: 16),
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
																														"Alamat Email",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 12,
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
																													color: Color(0xCCCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 11),
																														width: 16,
																														height: 13,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a8krs9r1_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 6),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"mizan.artisan@gmail.com",
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
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Row(
																																children: [
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xCCFFFFFF),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(9999),
																																					color: Color(0xFF50B0FF),
																																				),
																																				padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																				margin: const EdgeInsets.only( right: 5),
																																				child: Row(
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(9999),
																																							),
																																							margin: const EdgeInsets.only( right: 2),
																																							width: 10,
																																							height: 10,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(9999),
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pj1m2ny4_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																						Text(
																																							"Verif",
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
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				padding: const EdgeInsets.only( top: 2, bottom: 2, left: 4, right: 4),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Ubah",
																																							style: TextStyle(
																																								color: Color(0xFF000000),
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
																							margin: const EdgeInsets.only( bottom: 16),
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
																														"Nomor WhatsApp / Seluler",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 12,
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
																													color: Color(0xCCCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 12),
																														width: 12,
																														height: 18,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3xxic8j6_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( right: 6),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"+62 859-777-588-138",
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
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Row(
																																children: [
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xCCFFFFFF),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(9999),
																																					color: Color(0xFF50B0FF),
																																				),
																																				padding: const EdgeInsets.only( top: 3, bottom: 3, left: 9, right: 9),
																																				margin: const EdgeInsets.only( right: 5),
																																				child: Row(
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(9999),
																																							),
																																							margin: const EdgeInsets.only( right: 2),
																																							width: 10,
																																							height: 10,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(9999),
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3p2bcc91_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																						Text(
																																							"Verif",
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
																																	IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				padding: const EdgeInsets.only( top: 2, bottom: 2, left: 4, right: 4),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Text(
																																							"Ubah",
																																							style: TextStyle(
																																								color: Color(0xFF000000),
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
																							padding: const EdgeInsets.only( top: 4),
																							margin: const EdgeInsets.only( bottom: 16),
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
																														"Jenis Kelamin",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
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
																											child: Row(
																												children: [
																													Expanded(
																														child: InkWell(
																															onTap: () { print('Pressed'); },
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFF000000),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(12),
																																		color: Color(0xFF000000),
																																	),
																																	padding: const EdgeInsets.symmetric(vertical: 14),
																																	margin: const EdgeInsets.only( right: 4),
																																	width: double.infinity,
																																	child: Row(
																																		mainAxisAlignment: MainAxisAlignment.center,
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(12),
																																				),
																																				margin: const EdgeInsets.only( right: 7),
																																				width: 12,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(12),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/w7dnq7rb_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Laki-laki",
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
																													Expanded(
																														child: InkWell(
																															onTap: () { print('Pressed'); },
																															child: IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xCCCFC4C5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(12),
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.symmetric(vertical: 14),
																																	width: double.infinity,
																																	child: Row(
																																		mainAxisAlignment: MainAxisAlignment.center,
																																		children: [
																																			Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(12),
																																				),
																																				margin: const EdgeInsets.only( right: 8),
																																				width: 8,
																																				height: 12,
																																				child: ClipRRect(
																																					borderRadius: BorderRadius.circular(12),
																																					child: Image.network(
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/6nyl7q9o_expires_30_days.png",
																																						fit: BoxFit.fill,
																																					)
																																				)
																																			),
																																			Text(
																																				"Perempuan",
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
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 16),
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
																														"Tanggal Lahir",
																														style: TextStyle(
																															color: Color(0xFF1A1C1C),
																															fontSize: 12,
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
																													color: Color(0xCCCFC4C5),
																													width: 1,
																												),
																												borderRadius: BorderRadius.circular(12),
																												color: Color(0xFFFFFFFF),
																											),
																											padding: const EdgeInsets.only( top: 13, bottom: 13, left: 14, right: 14),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 11),
																														width: 15,
																														height: 16,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a75qx4ie_expires_30_days.png",
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
																																			"14 Agustus 1998",
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
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							alignment: Alignment.center,
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFFFFFFF),
																							),
																							width: double.infinity,
																							child: TextField(
																								style: TextStyle(
																									color: Color(0xFF5F5E5E),
																									fontSize: 12,
																								),
																								onChanged: (value) { 
																									setState(() { textField1 = value; });
																								},
																								decoration: InputDecoration(
																									hintText: "Pastikan data diri sesuai dengan identitas resmi untukkemudahan verifikasi pesanan dan pengirimankeramik di Aplikasi DinoyoCraft.",
																									isDense: true,
																									contentPadding: const EdgeInsets.only( top: 9, bottom: 9, left: 37, right: 37),
																									border: InputBorder.none,
																									focusedBorder: InputBorder.none,
																									filled: false,
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
																				color: Color(0x00FFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x1A000000),
																						blurRadius: 6,
																						offset: Offset(0, 4),
																					),
																				],
																			),
																			padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
																			margin: const EdgeInsets.symmetric(horizontal: 1),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					InkWell(
																						onTap: () { print('Pressed'); },
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
																								padding: const EdgeInsets.symmetric(vertical: 12),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.center,
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(9999),
																											),
																											margin: const EdgeInsets.only( right: 7),
																											width: 13,
																											height: 13,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(9999),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/3asvnklr_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Text(
																											"Simpan Perubahan",
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
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.symmetric(vertical: 4),
																							width: double.infinity,
																							child: Column(
																								children: [
																									Text(
																										"Batalkan",
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