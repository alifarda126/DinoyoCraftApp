import 'package:flutter/material.dart';
class ProfilPesananDikrim extends StatefulWidget {
	const ProfilPesananDikrim({super.key});
	@override
	ProfilPesananDikrimState createState() => ProfilPesananDikrimState();
}
class ProfilPesananDikrimState extends State<ProfilPesananDikrim> {
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
											padding: const EdgeInsets.symmetric(vertical: 13),
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/rp2naood_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wtitvk6s_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/73tf9e3z_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/l08th9gi_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x8gfkmxz_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nnlzysgd_expires_30_days.png",
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/2kcrhhu3_expires_30_days.png",
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/n02gr0n5_expires_30_days.png",
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
																									padding: const EdgeInsets.only( bottom: 53),
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
																																			margin: const EdgeInsets.only( right: 12),
																																			width: double.infinity,
																																			child: Column(
																																				children: [
																																					Text(
																																						"Dikirim",
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
																															Expanded(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			borderRadius: BorderRadius.circular(8),
																																		),
																																		padding: const EdgeInsets.symmetric(vertical: 8),
																																		width: double.infinity,
																																		child: Column(
																																			children: [
																																				Text(
																																					"Diterima",
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
																														]
																													),
																												),
																											),
																											IntrinsicHeight(
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
																																			decoration: BoxDecoration(
																																				border: Border.all(
																																					color: Color(0xFFCFC4C5),
																																					width: 1,
																																				),
																																				borderRadius: BorderRadius.circular(12),
																																				color: Color(0xFFFFFFFF),
																																			),
																																			padding: const EdgeInsets.only( top: 16, bottom: 16, left: 17, right: 17),
																																			width: double.infinity,
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					IntrinsicHeight(
																																						child: Container(
																																							margin: const EdgeInsets.only( bottom: 25),
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
																																															"#DNC-004",
																																															style: TextStyle(
																																																color: Color(0xFF1A1C1C),
																																																fontSize: 12,
																																																fontWeight: FontWeight.bold,
																																															),
																																														),
																																													),
																																													Text(
																																														"Karya Tanah",
																																														style: TextStyle(
																																															color: Color(0xFF5F5E5E),
																																															fontSize: 12,
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
																																														color: Color(0xFFCCCCCC),
																																														width: 1,
																																													),
																																													borderRadius: BorderRadius.circular(9999),
																																													color: Color(0xFFFFFFFF),
																																												),
																																												padding: const EdgeInsets.only( top: 3, bottom: 3, left: 12, right: 12),
																																												child: Column(
																																													crossAxisAlignment: CrossAxisAlignment.start,
																																													children: [
																																														Text(
																																															"Sedang Dikirim",
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
																																					IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0xFF000000),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(8),
																																								color: Color(0xFFFFFFFF),
																																							),
																																							padding: const EdgeInsets.all(9),
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
																																													IntrinsicWidth(
																																														child: IntrinsicHeight(
																																															child: Row(
																																																children: [
																																																	Container(
																																																		margin: const EdgeInsets.only( right: 6),
																																																		width: 14,
																																																		height: 10,
																																																		child: Image.network(
																																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/nspsjmku_expires_30_days.png",
																																																			fit: BoxFit.fill,
																																																		)
																																																	),
																																																	Text(
																																																		"J&T Express - Reguler",
																																																		style: TextStyle(
																																																			color: Color(0xFF000000),
																																																			fontSize: 12,
																																																		),
																																																	),
																																																]
																																															),
																																														),
																																													),
																																													Text(
																																														"JT92817294820",
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
																																												crossAxisAlignment: CrossAxisAlignment.start,
																																												children: [
																																													IntrinsicWidth(
																																														child: IntrinsicHeight(
																																															child: Container(
																																																padding: const EdgeInsets.only( top: 4),
																																																margin: const EdgeInsets.only( right: 8),
																																																child: Column(
																																																	children: [
																																																		Container(
																																																			decoration: BoxDecoration(
																																																				borderRadius: BorderRadius.circular(9999),
																																																				color: Color(0xFFFF0000),
																																																			),
																																																			width: 6,
																																																			height: 6,
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
																																																padding: const EdgeInsets.only( right: 38),
																																																width: double.infinity,
																																																child: Column(
																																																	crossAxisAlignment: CrossAxisAlignment.start,
																																																	children: [
																																																		Container(
																																																			width: double.infinity,
																																																			child: Text(
																																																				"Paket sedang dalam perjalanan menuju kota\nMalang (Hub Sukun)",
																																																				style: TextStyle(
																																																					color: Color(0xFFFF0024),
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
																																								]
																																							),
																																						),
																																					),
																																					IntrinsicHeight(
																																						child: Container(
																																							padding: const EdgeInsets.symmetric(vertical: 4),
																																							margin: const EdgeInsets.only( bottom: 16),
																																							width: double.infinity,
																																							child: Row(
																																								children: [
																																									Container(
																																										decoration: BoxDecoration(
																																											borderRadius: BorderRadius.circular(8),
																																										),
																																										margin: const EdgeInsets.only( right: 8),
																																										width: 80,
																																										height: 80,
																																										child: ClipRRect(
																																											borderRadius: BorderRadius.circular(8),
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x9trzr4i_expires_30_days.png",
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
																																																			"Cangkir Handmade Artisan",
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
																																																margin: const EdgeInsets.only( bottom: 6),
																																																width: double.infinity,
																																																child: Column(
																																																	crossAxisAlignment: CrossAxisAlignment.start,
																																																	children: [
																																																		Text(
																																																			"Karya Tanah Keramik Dinoyo",
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
																																																padding: const EdgeInsets.symmetric(vertical: 8),
																																																width: double.infinity,
																																																child: Row(
																																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																																	children: [
																																																		Text(
																																																			"Jumlah: 2",
																																																			style: TextStyle(
																																																				color: Color(0xFF5F5E5E),
																																																				fontSize: 12,
																																																			),
																																																		),
																																																		Text(
																																																			"Rp130.000",
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
																																									),
																																								]
																																							),
																																						),
																																					),
																																					IntrinsicHeight(
																																						child: Container(
																																							padding: const EdgeInsets.symmetric(vertical: 9),
																																							margin: const EdgeInsets.only( bottom: 16),
																																							width: double.infinity,
																																							child: Row(
																																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																								children: [
																																									Text(
																																										"Total (2 Produk):",
																																										style: TextStyle(
																																											color: Color(0xFF5F5E5E),
																																											fontSize: 12,
																																										),
																																									),
																																									Text(
																																										"Rp145.000",
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
																																							padding: const EdgeInsets.symmetric(vertical: 4),
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
																																															color: Color(0xFFCFC4C5),
																																															width: 1,
																																														),
																																														borderRadius: BorderRadius.circular(12),
																																														color: Color(0xFFFAF9F9),
																																													),
																																													padding: const EdgeInsets.symmetric(vertical: 12),
																																													margin: const EdgeInsets.only( right: 9),
																																													width: double.infinity,
																																													child: Row(
																																														mainAxisAlignment: MainAxisAlignment.center,
																																														children: [
																																															Container(
																																																decoration: BoxDecoration(
																																																	borderRadius: BorderRadius.circular(12),
																																																),
																																																margin: const EdgeInsets.only( right: 6),
																																																width: 14,
																																																height: 10,
																																																child: ClipRRect(
																																																	borderRadius: BorderRadius.circular(12),
																																																	child: Image.network(
																																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/7amhf5n0_expires_30_days.png",
																																																		fit: BoxFit.fill,
																																																	)
																																																)
																																															),
																																															Text(
																																																"Lacak Resi",
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
																																									Expanded(
																																										child: IntrinsicHeight(
																																											child: Container(
																																												decoration: BoxDecoration(
																																													borderRadius: BorderRadius.circular(12),
																																													color: Color(0xFF000000),
																																												),
																																												padding: const EdgeInsets.only( top: 12, bottom: 12, left: 20, right: 20),
																																												width: double.infinity,
																																												child: Row(
																																													children: [
																																														Container(
																																															decoration: BoxDecoration(
																																																borderRadius: BorderRadius.circular(12),
																																															),
																																															margin: const EdgeInsets.only( right: 6),
																																															width: 13,
																																															height: 13,
																																															child: ClipRRect(
																																																borderRadius: BorderRadius.circular(12),
																																																child: Image.network(
																																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/szo1wfuc_expires_30_days.png",
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
																																																				"Hubungi Penjual",
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
																																right: 10,
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
																																				transform: Matrix4.translationValues(0, 29, 0),
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
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/6voooobl_expires_30_days.png",
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/w92e642w_expires_30_days.png",
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/26580ki2_expires_30_days.png",
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ryl1n1qg_expires_30_days.png",
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lswxkm3r_expires_30_days.png",
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/lemo8r9g_expires_30_days.png",
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
																																																		padding: const EdgeInsets.only( right: 67),
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
																																																"Kelola aplikasi dan privasi",
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/bpoy6ipx_expires_30_days.png",
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
																																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a9wcmlnn_expires_30_days.png",
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/q0k0yamm_expires_30_days.png",
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
																											borderRadius: BorderRadius.circular(39),
																											color: Color(0xFFFFFFFF),
																										),
																										padding: const EdgeInsets.symmetric(vertical: 13),
																										margin: const EdgeInsets.only( bottom: 24),
																										width: double.infinity,
																										child: Row(
																											mainAxisAlignment: MainAxisAlignment.center,
																											children: [
																												Container(
																													decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(39),
																													),
																													margin: const EdgeInsets.only( right: 8),
																													width: 16,
																													height: 16,
																													child: ClipRRect(
																														borderRadius: BorderRadius.circular(39),
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mph4wrus_expires_30_days.png",
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
																							IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( top: 27),
																									width: double.infinity,
																									child: Column(
																										children: [
																											Text(
																												"DinoyoCraft",
																												style: TextStyle(
																													color: Color(0xFF888888),
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
																		]
																	),
																	Positioned(
																		bottom: 479,
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
																																width: 20,
																																height: 20,
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/1hb3auta_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															),
																															IntrinsicHeight(
																																child: Container(
																																	padding: const EdgeInsets.only( top: 4),
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/8x9h1671_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/708lwwia_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5j3y5h13_expires_30_days.png",
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