import 'package:flutter/material.dart';
class ProfilPesananDikemas extends StatefulWidget {
	const ProfilPesananDikemas({super.key});
	@override
	ProfilPesananDikemasState createState() => ProfilPesananDikemasState();
}
class ProfilPesananDikemasState extends State<ProfilPesananDikemas> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/c5s27iuw_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/oqzwp0zz_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mr87zzro_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/7x1cpd1k_expires_30_days.png",
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
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/tjx3u8jt_expires_30_days.png",
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/gpl0dxz6_expires_30_days.png",
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/ozse4cvt_expires_30_days.png",
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/c0dz9ncg_expires_30_days.png",
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
																									padding: const EdgeInsets.only( bottom: 1),
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
																																			margin: const EdgeInsets.only( right: 9),
																																			width: double.infinity,
																																			child: Column(
																																				children: [
																																					Text(
																																						"Dikemas",
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
																																		margin: const EdgeInsets.only( right: 9),
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
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0xFFCCCCCC),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(16),
																														color: Color(0xFFFFFFFF),
																													),
																													padding: const EdgeInsets.only( top: 17, bottom: 17, left: 15, right: 15),
																													margin: const EdgeInsets.only( bottom: 12),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															IntrinsicHeight(
																																child: Container(
																																	margin: const EdgeInsets.only( bottom: 10),
																																	width: double.infinity,
																																	child: Row(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Expanded(
																																				child: IntrinsicHeight(
																																					child: Container(
																																						margin: const EdgeInsets.only( right: 35),
																																						width: double.infinity,
																																						child: Row(
																																							children: [
																																								Container(
																																									margin: const EdgeInsets.only( right: 8),
																																									child: Text(
																																										"#DNC-001",
																																										style: TextStyle(
																																											color: Color(0xFF000000),
																																											fontSize: 11,
																																											fontWeight: FontWeight.bold,
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
																																															color: Color(0xFF888888),
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
																																						padding: const EdgeInsets.only( bottom: 6, left: 9, right: 9),
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								Text(
																																									"Dikemas Penjual",
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
																																	margin: const EdgeInsets.only( bottom: 10),
																																	width: double.infinity,
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( bottom: 5),
																																					width: double.infinity,
																																					child: Row(
																																						children: [
																																							Container(
																																								margin: const EdgeInsets.only( right: 6),
																																								width: 14,
																																								height: 10,
																																								child: Image.network(
																																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xxrxb8i3_expires_30_days.png",
																																									fit: BoxFit.fill,
																																								)
																																							),
																																							Text(
																																								"Menyerahkan ke Pihak Jasa Kirim",
																																								style: TextStyle(
																																									color: Color(0xFF000000),
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
																																														color: Color(0xFFFFD400),
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
																																										width: double.infinity,
																																										child: Column(
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Container(
																																													width: 281,
																																													child: Text(
																																														"Paket sedang dalam perjalanan untuk diserahkan\nke Pihak Jasa Kirim",
																																														style: TextStyle(
																																															color: Color(0xFFFFD400),
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
																																	margin: const EdgeInsets.only( bottom: 10),
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
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/1ybit8t9_expires_30_days.png",
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
																																										margin: const EdgeInsets.only( bottom: 5),
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
																																																	"Topeng Messi",
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
																																											]
																																										),
																																									),
																																								),
																																								IntrinsicHeight(
																																									child: Container(
																																										padding: const EdgeInsets.only( top: 11),
																																										width: double.infinity,
																																										child: Row(
																																											mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																											crossAxisAlignment: CrossAxisAlignment.start,
																																											children: [
																																												Text(
																																													"Jumlah: 1",
																																													style: TextStyle(
																																														color: Color(0xFF5F5E5E),
																																														fontSize: 12,
																																													),
																																												),
																																												Text(
																																													"Rp20.000",
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
																																	width: double.infinity,
																																	child: Row(
																																		mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																		children: [
																																			Text(
																																				"Total (1 Produk):",
																																				style: TextStyle(
																																					color: Color(0xFF5F5E5E),
																																					fontSize: 12,
																																				),
																																			),
																																			Text(
																																				"Rp25.000",
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
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/a0orjalm_expires_30_days.png",
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
																									margin: const EdgeInsets.only( bottom: 24),
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
																																	color: Color(0xFFCCCCCC),
																																	width: 1,
																																),
																																borderRadius: BorderRadius.circular(16),
																																color: Color(0x82FFFFFF),
																															),
																															padding: const EdgeInsets.all(1),
																															margin: const EdgeInsets.only( top: 36, bottom: 12),
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
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/op0cetgm_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										)
																																									),
																																									IntrinsicWidth(
																																										child: IntrinsicHeight(
																																											child: Column(
																																												crossAxisAlignment: CrossAxisAlignment.start,
																																												children: [
																																													Container(
																																														margin: const EdgeInsets.only( right: 107),
																																														child: Text(
																																															"Data Diri",
																																															style: TextStyle(
																																																color: Color(0xFF1A1A1A),
																																																fontSize: 14,
																																																fontWeight: FontWeight.bold,
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
																																					Container(
																																						width: 16,
																																						height: 16,
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/opd4t4d8_expires_30_days.png",
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
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/85i182ea_expires_30_days.png",
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
																																					Container(
																																						width: 16,
																																						height: 16,
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xmoyjvl5_expires_30_days.png",
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
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/hpbw7mhe_expires_30_days.png",
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
																																					Container(
																																						width: 16,
																																						height: 16,
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/b2mi8w6x_expires_30_days.png",
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
																																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vp4j4sf2_expires_30_days.png",
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
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/96vtvipw_expires_30_days.png",
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
																											Positioned(
																												top: 0,
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
																																transform: Matrix4.translationValues(0, -16, 0),
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
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/t71hdj1o_expires_30_days.png",
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
																							InkWell(
																								onTap: () { print('Pressed'); },
																								child: IntrinsicHeight(
																									child: Container(
																										decoration: BoxDecoration(
																											border: Border.all(
																												color: Color(0xFFFF0000),
																												width: 1,
																											),
																											borderRadius: BorderRadius.circular(32),
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
																														borderRadius: BorderRadius.circular(32),
																													),
																													margin: const EdgeInsets.only( right: 8),
																													width: 16,
																													height: 16,
																													child: ClipRRect(
																														borderRadius: BorderRadius.circular(32),
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/w0jpgxac_expires_30_days.png",
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
																		bottom: 399,
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/im5xfqso_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/45fi9rlt_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/19b4r8pe_expires_30_days.png",
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
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/irw8eyey_expires_30_days.png",
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