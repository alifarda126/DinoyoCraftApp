import 'package:flutter/material.dart';
class ProfilPesananDiterima extends StatefulWidget {
	const ProfilPesananDiterima({super.key});
	@override
	ProfilPesananDiterimaState createState() => ProfilPesananDiterimaState();
}
class ProfilPesananDiterimaState extends State<ProfilPesananDiterima> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5b1g9o1k_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 20),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hkh2cumn_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/d9yvcvbq_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/c8pl8zus_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lu90kie5_expires_30_days.png",
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
															margin: const EdgeInsets.symmetric(horizontal: 16),
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					padding: const EdgeInsets.only( bottom: 1),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.symmetric(vertical: 6),
																									margin: const EdgeInsets.only( bottom: 24),
																									width: double.infinity,
																									child: Column(
																										children: [
																											Container(
																												width: 80,
																												height: 92,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/4a858wdh_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( bottom: 1),
																												child: Text(
																													"Mochammad Al Mizan Ya Hafidl",
																													style: TextStyle(
																														color: Color(0xFF1A1A1A),
																														fontSize: 20,
																														fontWeight: FontWeight.bold,
																													),
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( bottom: 14),
																												child: Text(
																													"@mizanyf",
																													style: TextStyle(
																														color: Color(0xFF888888),
																														fontSize: 13,
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
																																	color: Color(0xFF000000),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(9999),
																																color: Color(0xFFFFFFFF),
																															),
																															padding: const EdgeInsets.only( top: 7, bottom: 7, left: 16, right: 16),
																															child: Row(
																																children: [
																																	Container(
																																		decoration: BoxDecoration(
																																			borderRadius: BorderRadius.circular(9999),
																																		),
																																		margin: const EdgeInsets.only( right: 6),
																																		width: 14,
																																		height: 14,
																																		child: ClipRRect(
																																			borderRadius: BorderRadius.circular(9999),
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/bb8cdjgg_expires_30_days.png",
																																				fit: BoxFit.fill,
																																			)
																																		)
																																	),
																																	Container(
																																		margin: const EdgeInsets.only( right: 6),
																																		child: Text(
																																			"Data Diri",
																																			style: TextStyle(
																																				color: Color(0xFF1A1A1A),
																																				fontSize: 13,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	),
																																	Container(
																																		decoration: BoxDecoration(
																																			borderRadius: BorderRadius.circular(9999),
																																		),
																																		width: 14,
																																		height: 14,
																																		child: ClipRRect(
																																			borderRadius: BorderRadius.circular(9999),
																																			child: Image.network(
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/tmn9gk04_expires_30_days.png",
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
																																"Riwayat Pesanan",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
																																	fontSize: 16,
																																	fontWeight: FontWeight.bold,
																																),
																															),
																															IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			border: Border.all(
																																				color: Color(0xFFE5E5E5),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(4),
																																			color: Color(0xFFFFFFFF),
																																		),
																																		padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																																		child: Column(
																																			crossAxisAlignment: CrossAxisAlignment.start,
																																			children: [
																																				Text(
																																					"1 Pesanan",
																																					style: TextStyle(
																																						color: Color(0xFF666666),
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
																															color: Color(0xFFCCCCCC),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(12),
																														color: Color(0xFFFFFFFF),
																													),
																													padding: const EdgeInsets.all(5),
																													margin: const EdgeInsets.only( bottom: 12),
																													width: double.infinity,
																													child: Row(
																														children: [
																															Expanded(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			borderRadius: BorderRadius.circular(8),
																																		),
																																		padding: const EdgeInsets.symmetric(vertical: 8),
																																		margin: const EdgeInsets.only( right: 3),
																																		width: double.infinity,
																																		child: Column(
																																			children: [
																																				Text(
																																					"Dikemas",
																																					style: TextStyle(
																																						color: Color(0xFF666666),
																																						fontSize: 13,
																																						fontWeight: FontWeight.bold,
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
																																			borderRadius: BorderRadius.circular(8),
																																		),
																																		padding: const EdgeInsets.symmetric(vertical: 8),
																																		margin: const EdgeInsets.only( right: 16),
																																		width: double.infinity,
																																		child: Column(
																																			children: [
																																				Text(
																																					"Dikirim",
																																					style: TextStyle(
																																						color: Color(0xFF666666),
																																						fontSize: 13,
																																						fontWeight: FontWeight.bold,
																																					),
																																				),
																																			]
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
																																				borderRadius: BorderRadius.circular(8),
																																				color: Color(0xFF000000),
																																				boxShadow: [
																																					BoxShadow(
																																						color: Color(0x0D000000),
																																						blurRadius: 2,
																																						offset: Offset(0, 1),
																																					),
																																				],
																																			),
																																			padding: const EdgeInsets.symmetric(vertical: 8),
																																			width: double.infinity,
																																			child: Column(
																																				children: [
																																					Text(
																																						"Diterima",
																																						style: TextStyle(
																																							color: Color(0xFFFFFFFF),
																																							fontSize: 13,
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
																											IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( top: 4),
																													margin: const EdgeInsets.only( bottom: 12),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															IntrinsicHeight(
																																child: Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0xFFE5E5E5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(16),
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.all(15),
																																	margin: const EdgeInsets.only( bottom: 12),
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( bottom: 11),
																																					margin: const EdgeInsets.only( bottom: 12),
																																					width: double.infinity,
																																					child: Row(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Expanded(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										margin: const EdgeInsets.only( right: 13),
																																										width: double.infinity,
																																										child: Row(
																																											children: [
																																												Container(
																																													margin: const EdgeInsets.only( right: 6),
																																													child: Text(
																																														"#DNC-001",
																																														style: TextStyle(
																																															color: Color(0xFF1A1C1C),
																																															fontSize: 12,
																																															fontWeight: FontWeight.bold,
																																														),
																																													),
																																												),
																																												Container(
																																													margin: const EdgeInsets.only( right: 5),
																																													child: Text(
																																														"•",
																																														style: TextStyle(
																																															color: Color(0xFF848484),
																																															fontSize: 10,
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
																																																		"Dinoyo Ceramic Studio",
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
																																							),
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										decoration: BoxDecoration(
																																											border: Border.all(
																																												color: Color(0xFFE5E5E5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(9999),
																																											color: Color(0xFFF4F3F3),
																																										),
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 8, right: 8),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"Pesanan Selesai",
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
																																					margin: const EdgeInsets.only( bottom: 12),
																																					width: double.infinity,
																																					child: Row(
																																						children: [
																																							Container(
																																								margin: const EdgeInsets.only( right: 6),
																																								width: 11,
																																								height: 13,
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pcdnd2lj_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							),
																																							Text(
																																								"Diterima pada 12 Feb 2025 - Diterima oleh Penerima",
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
																																					margin: const EdgeInsets.only( bottom: 12),
																																					width: double.infinity,
																																					child: Row(
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(12),
																																								),
																																								margin: const EdgeInsets.only( right: 12),
																																								width: 72,
																																								height: 72,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(12),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/k1czazts_expires_30_days.png",
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
																																														margin: const EdgeInsets.only( bottom: 1),
																																														width: double.infinity,
																																														child: Column(
																																															crossAxisAlignment: CrossAxisAlignment.start,
																																															children: [
																																																Text(
																																																	"Vas Keramik Minimalis",
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
																																														margin: const EdgeInsets.only( bottom: 1),
																																														width: double.infinity,
																																														child: Column(
																																															crossAxisAlignment: CrossAxisAlignment.start,
																																															children: [
																																																Text(
																																																	"Sand White Glossy • 1x",
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
																																														padding: const EdgeInsets.symmetric(vertical: 2),
																																														width: double.infinity,
																																														child: Row(
																																															children: [
																																																Expanded(
																																																	child: IntrinsicHeight(
																																																		child: Container(
																																																			margin: const EdgeInsets.only( right: 36),
																																																			width: double.infinity,
																																																			child: Column(
																																																				crossAxisAlignment: CrossAxisAlignment.start,
																																																				children: [
																																																					Text(
																																																						"Harga: Rp85.000",
																																																						style: TextStyle(
																																																							color: Color(0xFF848484),
																																																							fontSize: 12,
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
																																																			width: double.infinity,
																																																			child: Column(
																																																				crossAxisAlignment: CrossAxisAlignment.start,
																																																				children: [
																																																					Text(
																																																						"Total: Rp102.000",
																																																						style: TextStyle(
																																																							color: Color(0xFF1A1C1C),
																																																							fontSize: 13,
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
																																				),
																																			),
																																			IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( top: 5, bottom: 5, left: 3, right: 3),
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
																																													color: Color(0xFFE5E5E5),
																																													width: 1,
																																												),
																																												borderRadius: BorderRadius.circular(12),
																																												color: Color(0xFFFFFFFF),
																																											),
																																											padding: const EdgeInsets.symmetric(vertical: 9),
																																											margin: const EdgeInsets.only( right: 8),
																																											width: double.infinity,
																																											child: Column(
																																												children: [
																																													Text(
																																														"Beri Ulasan",
																																														style: TextStyle(
																																															color: Color(0xFF1A1C1C),
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
																																							Expanded(
																																								child: InkWell(
																																									onTap: () { print('Pressed'); },
																																									child: IntrinsicHeight(
																																										child: Container(
																																											decoration: BoxDecoration(
																																												borderRadius: BorderRadius.circular(12),
																																												color: Color(0xFF000000),
																																											),
																																											padding: const EdgeInsets.symmetric(vertical: 8),
																																											width: double.infinity,
																																											child: Column(
																																												children: [
																																													Text(
																																														"Beli Lagi",
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
																																		border: Border.all(
																																			color: Color(0xFFE5E5E5),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(16),
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.all(15),
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( bottom: 11),
																																					margin: const EdgeInsets.only( bottom: 12),
																																					width: double.infinity,
																																					child: Row(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Expanded(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										margin: const EdgeInsets.only( right: 29),
																																										width: double.infinity,
																																										child: Row(
																																											children: [
																																												Container(
																																													margin: const EdgeInsets.only( right: 6),
																																													child: Text(
																																														"#DNC-000",
																																														style: TextStyle(
																																															color: Color(0xFF1A1C1C),
																																															fontSize: 12,
																																															fontWeight: FontWeight.bold,
																																														),
																																													),
																																												),
																																												Container(
																																													margin: const EdgeInsets.only( right: 6),
																																													child: Text(
																																														"•",
																																														style: TextStyle(
																																															color: Color(0xFF848484),
																																															fontSize: 10,
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
																																																		"Ruang Tanah Studio",
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
																																							),
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										decoration: BoxDecoration(
																																											border: Border.all(
																																												color: Color(0xFFE5E5E5),
																																												width: 1,
																																											),
																																											borderRadius: BorderRadius.circular(9999),
																																											color: Color(0xFFF4F3F3),
																																										),
																																										padding: const EdgeInsets.only( top: 3, bottom: 3, left: 8, right: 8),
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"Pesanan Selesai",
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
																																					margin: const EdgeInsets.only( bottom: 12),
																																					width: double.infinity,
																																					child: Row(
																																						children: [
																																							Container(
																																								margin: const EdgeInsets.only( right: 6),
																																								width: 11,
																																								height: 13,
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cpysndmd_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							),
																																							Expanded(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										padding: const EdgeInsets.only( right: 14),
																																										width: double.infinity,
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Container(
																																													width: double.infinity,
																																													child: Text(
																																														"Diterima pada 28 Jan 2025 - Diterima oleh Satpam",
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
																																			IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( bottom: 12),
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
																																											child: Row(
																																												children: [
																																													Container(
																																														decoration: BoxDecoration(
																																															borderRadius: BorderRadius.circular(12),
																																														),
																																														margin: const EdgeInsets.only( right: 12),
																																														width: 72,
																																														height: 72,
																																														child: ClipRRect(
																																															borderRadius: BorderRadius.circular(12),
																																															child: Image.network(
																																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/uusudni3_expires_30_days.png",
																																																fit: BoxFit.fill,
																																															)
																																														)
																																													),
																																													Expanded(
																																														child: IntrinsicHeight(
																																															child: Container(
																																																padding: const EdgeInsets.only( bottom: 42),
																																																width: double.infinity,
																																																child: Column(
																																																	crossAxisAlignment: CrossAxisAlignment.start,
																																																	children: [
																																																		Text(
																																																			"Mangkuk Keramik Artisanal",
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
																																													),
																																												]
																																											),
																																										),
																																									),
																																								]
																																							),
																																							Positioned(
																																								top: 9,
																																								right: 0,
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
																																												padding: const EdgeInsets.all(14),
																																												transform: Matrix4.translationValues(5, 0, 0),
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
																																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/46uhoojf_expires_30_days.png",
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
																																			IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( top: 5, bottom: 5, left: 3, right: 3),
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
																																													color: Color(0xFFE5E5E5),
																																													width: 1,
																																												),
																																												borderRadius: BorderRadius.circular(12),
																																												color: Color(0xFFFFFFFF),
																																											),
																																											padding: const EdgeInsets.symmetric(vertical: 9),
																																											margin: const EdgeInsets.only( right: 8),
																																											width: double.infinity,
																																											child: Column(
																																												children: [
																																													Text(
																																														"Lihat Ulasan",
																																														style: TextStyle(
																																															color: Color(0xFF1A1C1C),
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
																																							Expanded(
																																								child: InkWell(
																																									onTap: () { print('Pressed'); },
																																									child: IntrinsicHeight(
																																										child: Container(
																																											decoration: BoxDecoration(
																																												borderRadius: BorderRadius.circular(12),
																																												color: Color(0xFF000000),
																																											),
																																											padding: const EdgeInsets.symmetric(vertical: 8),
																																											width: double.infinity,
																																											child: Column(
																																												children: [
																																													Text(
																																														"Beli Lagi",
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
																											InkWell(
																												onTap: () { print('Pressed'); },
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															border: Border.all(
																																color: Color(0xFF000000),
																																width: 1,
																															),
																															borderRadius: BorderRadius.circular(12),
																															color: Color(0xFFFFFFFF),
																														),
																														padding: const EdgeInsets.symmetric(vertical: 11),
																														width: double.infinity,
																														child: Row(
																															mainAxisAlignment: MainAxisAlignment.center,
																															children: [
																																Container(
																																	margin: const EdgeInsets.only( right: 6),
																																	child: Text(
																																		"Lihat Semua Pesanan",
																																		style: TextStyle(
																																			color: Color(0xFF1A1A1A),
																																			fontSize: 13,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																),
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(12),
																																	),
																																	width: 16,
																																	height: 16,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(12),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/2jo1bpxe_expires_30_days.png",
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
																									padding: const EdgeInsets.symmetric(vertical: 8),
																									margin: const EdgeInsets.only( bottom: 24),
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
																															Text(
																																"Akun",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
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
																															color: Color(0xFFCCCCCC),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(16),
																														color: Color(0x82FFFFFF),
																													),
																													padding: const EdgeInsets.all(1),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 14, bottom: 14, left: 16, right: 16),
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
																																								margin: const EdgeInsets.only( right: 14),
																																								width: 36,
																																								height: 36,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(12),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a0tjp2l2_expires_30_days.png",
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
																																													child: Column(
																																														children: [
																																															IntrinsicWidth(
																																																child: IntrinsicHeight(
																																																	child: Container(
																																																		padding: const EdgeInsets.only( right: 107),
																																																		child: Column(
																																																			crossAxisAlignment: CrossAxisAlignment.start,
																																																			children: [
																																																				Text(
																																																					"Data Diri",
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
																																															Text(
																																																"Kelola informasi akun & profil",
																																																style: TextStyle(
																																																	color: Color(0xFF000000),
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
																																			Container(
																																				width: 16,
																																				height: 16,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cy1farpk_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																		]
																																	),
																																),
																															),
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
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
																																								margin: const EdgeInsets.only( right: 14),
																																								width: 36,
																																								height: 36,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(12),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rx9xzu2x_expires_30_days.png",
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
																																													child: Column(
																																														children: [
																																															IntrinsicWidth(
																																																child: IntrinsicHeight(
																																																	child: Container(
																																																		padding: const EdgeInsets.only( right: 38),
																																																		child: Column(
																																																			crossAxisAlignment: CrossAxisAlignment.start,
																																																			children: [
																																																				Text(
																																																					"Alamat Pengiriman",
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
																																															Text(
																																																"Kelola alamat tujuan pesanan",
																																																style: TextStyle(
																																																	color: Color(0xFF000000),
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
																																			Container(
																																				width: 16,
																																				height: 16,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ceppxv6b_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																		]
																																	),
																																),
																															),
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
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
																																								margin: const EdgeInsets.only( right: 14),
																																								width: 36,
																																								height: 36,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(12),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/jbjc19jh_expires_30_days.png",
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
																																													child: Column(
																																														children: [
																																															IntrinsicWidth(
																																																child: IntrinsicHeight(
																																																	child: Container(
																																																		padding: const EdgeInsets.only( right: 73),
																																																		child: Column(
																																																			crossAxisAlignment: CrossAxisAlignment.start,
																																																			children: [
																																																				Text(
																																																					"Pengaturan",
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
																																															Text(
																																																"Notifikasi, bahasa & privasi",
																																																style: TextStyle(
																																																	color: Color(0xFF000000),
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
																																			Container(
																																				width: 16,
																																				height: 16,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/obus3qgi_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			),
																																		]
																																	),
																																),
																															),
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																																	width: double.infinity,
																																	child: Row(
																																		children: [
																																			Expanded(
																																				child: IntrinsicHeight(
																																					child: Container(
																																						margin: const EdgeInsets.only( right: 43),
																																						width: double.infinity,
																																						child: Row(
																																							children: [
																																								Container(
																																									decoration: BoxDecoration(
																																										borderRadius: BorderRadius.circular(12),
																																									),
																																									margin: const EdgeInsets.only( right: 14),
																																									width: 36,
																																									height: 36,
																																									child: ClipRRect(
																																										borderRadius: BorderRadius.circular(12),
																																										child: Image.network(
																																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lucskrob_expires_30_days.png",
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
																																																		"Bantuan",
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
																																													IntrinsicHeight(
																																														child: Container(
																																															width: double.infinity,
																																															child: Column(
																																																crossAxisAlignment: CrossAxisAlignment.start,
																																																children: [
																																																	Text(
																																																		"Temukan jawaban yang Anda butuhkan",
																																																		style: TextStyle(
																																																			color: Color(0xFF000000),
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
																																							]
																																						),
																																					),
																																				),
																																			),
																																			Container(
																																				width: 16,
																																				height: 16,
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/yvvpzbua_expires_30_days.png",
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
																							InkWell(
																								onTap: () { print('Pressed'); },
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											border: Border.all(
																												color: Color(0xFFFF0000),
																												width: 1,
																											),
																											borderRadius: BorderRadius.circular(35),
																											color: Color(0xFFFFFFFF),
																										),
																										padding: const EdgeInsets.symmetric(vertical: 13),
																										width: double.infinity,
																										child: Row(
																											mainAxisAlignment: MainAxisAlignment.center,
																											children: [
																												Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(35),
																													),
																													margin: const EdgeInsets.only( right: 8),
																													width: 16,
																													height: 16,
																													child: ClipRRect(
																														borderRadius: BorderRadius.circular(35),
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/pahtar7u_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													)
																												),
																												Text(
																													"Keluar dari Akun",
																													style: TextStyle(
																														color: Color(0xFFFF0000),
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
																		]
																	),
																	Positioned(
																		bottom: 516,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(10),
																					color: Color(0x80FFFFFF),
																				),
																				padding: const EdgeInsets.only( top: 10, bottom: 10, left: 29, right: 29),
																				transform: Matrix4.translationValues(16, 0, 0),
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
																													margin: const EdgeInsets.only( right: 29),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ns9qei6u_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5gtjxcc2_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lxks9cae_expires_30_days.png",
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
																													margin: const EdgeInsets.only( right: 28),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cup6t4kk_expires_30_days.png",
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
																										Expanded(
																											child: IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( top: 32),
																													width: double.infinity,
																													child: Column(
																														children: [
																															Text(
																																"Profil",
																																style: TextStyle(
																																	color: Color(0xFF1A1A1A),
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