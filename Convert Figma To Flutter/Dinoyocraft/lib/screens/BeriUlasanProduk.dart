import 'package:flutter/material.dart';
class BeriUlasanProduk extends StatefulWidget {
	const BeriUlasanProduk({super.key});
	@override
	BeriUlasanProdukState createState() => BeriUlasanProdukState();
}
class BeriUlasanProdukState extends State<BeriUlasanProduk> {
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/m2nqbtbh_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 18),
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
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/yras7hir_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Text(
																						"Beri Ulasan Produk",
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
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/21d8k8j4_expires_30_days.png",
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
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.all(9),
															margin: const EdgeInsets.only( bottom: 16, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(8),
																		),
																		margin: const EdgeInsets.only( right: 8),
																		width: 64,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(8),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/x2e6morp_expires_30_days.png",
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
																								margin: const EdgeInsets.only( bottom: 2),
																								width: double.infinity,
																								child: Row(
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 4),
																											child: Text(
																												"#DNC-001",
																												style: TextStyle(
																													color: Color(0xFF1A1C1C),
																													fontSize: 12,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										),
																										Text(
																											"Diterima 12 Feb 2025",
																											style: TextStyle(
																												color: Color(0xFF5F5E5E),
																												fontSize: 12,
																											),
																										),
																									]
																								),
																							),
																						),
																						Container(
																							margin: const EdgeInsets.only( bottom: 2),
																							child: Text(
																								"Vas Keramik Minimalis",
																								style: TextStyle(
																									color: Color(0xFF1A1C1C),
																									fontSize: 14,
																									fontWeight: FontWeight.bold,
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
																											"Varian: Sand White Glossy 1x",
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
																										Container(
																											margin: const EdgeInsets.only( right: 4),
																											width: 11,
																											height: 10,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/usjx56hy_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
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
																	color: Color(0xFFCFC4C5),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.symmetric(vertical: 17),
															margin: const EdgeInsets.only( bottom: 16, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 2),
																		child: Text(
																			"Bagaimana kualitas keramik ini?",
																			style: TextStyle(
																				color: Color(0xFF1A1C1C),
																				fontSize: 16,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		margin: const EdgeInsets.only( bottom: 16),
																		width: 252,
																		child: Text(
																			"Sentuh bintang untuk memberikan penilaian\nkeseluruhan",
																			style: TextStyle(
																				color: Color(0xFF5F5E5E),
																				fontSize: 12,
																			),
																			textAlign: TextAlign.center,
																		),
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( bottom: 24),
																				child: Row(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( right: 8),
																							width: 39,
																							height: 46,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/cu4t1rt7_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Container(
																							margin: const EdgeInsets.only( right: 8),
																							width: 39,
																							height: 46,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wha61jo6_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Container(
																							margin: const EdgeInsets.only( right: 8),
																							width: 39,
																							height: 46,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/wiaeqwip_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Container(
																							margin: const EdgeInsets.only( right: 8),
																							width: 39,
																							height: 46,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/mw9d159m_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Container(
																							width: 39,
																							height: 46,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/y96k0a7p_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
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
																					color: Color(0xFFF4F3F3),
																				),
																				padding: const EdgeInsets.only( top: 5, bottom: 5, left: 13, right: 13),
																				margin: const EdgeInsets.only( bottom: 25),
																				child: Row(
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(9999),
																								color: Color(0xFFF59E0B),
																							),
																							margin: const EdgeInsets.only( right: 6),
																							width: 8,
																							height: 8,
																							child: SizedBox(),
																						),
																						Text(
																							"Sangat Memuaskan 5/5 ★",
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
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.symmetric(horizontal: 17),
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
																									Text(
																										"Pilih hal yang paling kamu sukai:",
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
																							padding: const EdgeInsets.only( right: 35),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 8),
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
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFF000000),
																																	),
																																	padding: const EdgeInsets.symmetric(vertical: 7),
																																	margin: const EdgeInsets.only( right: 8),
																																	width: double.infinity,
																																	child: Column(
																																		children: [
																																			Text(
																																				"✓ Finishing Halus",
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
																																			color: Color(0xFF000000),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(9999),
																																		color: Color(0xFF000000),
																																	),
																																	padding: const EdgeInsets.symmetric(vertical: 7),
																																	width: double.infinity,
																																	child: Column(
																																		children: [
																																			Text(
																																				"✓ Packing Kayu Aman",
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
																															color: Color(0xFF000000),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(9999),
																														color: Color(0xFF000000),
																													),
																													padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																													margin: const EdgeInsets.only( bottom: 8),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"✓ Warna Sesuai Foto",
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
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Row(
																												children: [
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
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																	margin: const EdgeInsets.only( right: 8),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"+ Kualitas Tebal & Kokoh",
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
																																		color: Color(0xFFFFFFFF),
																																	),
																																	padding: const EdgeInsets.only( top: 7, bottom: 7, left: 13, right: 13),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"+ Detail Rapi",
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
																	color: Color(0xFFCFC4C5),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.all(17),
															margin: const EdgeInsets.only( bottom: 16, left: 16, right: 16),
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
																					Text(
																						"Penilaian Khusus Tembikar",
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
																			padding: const EdgeInsets.symmetric(vertical: 4),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 31),
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
																															"Kualitas Bahan & Glaze",
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
																															"Ketahanan lapisan dan kilau glasir",
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
																					Container(
																						width: 99,
																						height: 15,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/e3t41c24_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	Container(
																		color: Color(0x99CFC4C5),
																		margin: const EdgeInsets.only( bottom: 8),
																		height: 1,
																		width: double.infinity,
																		child: SizedBox(),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.symmetric(vertical: 4),
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 32),
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
																															"Ketepatan dengan Deskripsi",
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
																														Container(
																															width: 157,
																															child: Text(
																																"Dimensi, warna, dan tekstur\nkerajinan",
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
																					Container(
																						width: 99,
																						height: 15,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/fol3jj7o_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	Container(
																		color: Color(0x99CFC4C5),
																		margin: const EdgeInsets.only( bottom: 8),
																		height: 1,
																		width: double.infinity,
																		child: SizedBox(),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.symmetric(vertical: 4),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Column(
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( right: 17),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															width: 149,
																															child: Text(
																																"Keamanan Kemasan &\nEkspedisi",
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
																									),
																									Container(
																										width: 166,
																										child: Text(
																											"Bubble wrap tebal & proteksi\nbenturan",
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
																					Container(
																						width: 99,
																						height: 15,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/5fpmeprp_expires_30_days.png",
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
															decoration: BoxDecoration(
																border: Border.all(
																	color: Color(0xFFCFC4C5),
																	width: 1,
																),
																borderRadius: BorderRadius.circular(12),
																color: Color(0xFFFFFFFF),
															),
															padding: const EdgeInsets.all(17),
															margin: const EdgeInsets.only( bottom: 28, left: 16, right: 16),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 8),
																			width: double.infinity,
																			child: Column(
																				children: [
																					Text(
																						"Ulasan Tertulis",
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
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFCFC4C5),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFF4F3F3),
																							),
																							padding: const EdgeInsets.all(13),
																							margin: const EdgeInsets.only( bottom: 11),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: double.infinity,
																										child: Text(
																											"Glasirnya sangat rapi dan tekstur tanah liat \nDinoyonya terasa kokoh serta otentik. \nPengemasan kayu sangat aman sampai di \nrumah tanpa retak sedikitpun. \nRecommended!",
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
																							padding: const EdgeInsets.only( right: 1),
																							margin: const EdgeInsets.only( bottom: 11),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.end,
																								children: [
																									Text(
																										"162/500",
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
																							padding: const EdgeInsets.symmetric(vertical: 4),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 7),
																											width: double.infinity,
																											child: Column(
																												children: [
																													Text(
																														"Tambahkan Foto Produk",
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
																																			color: Color(0xFFCFC4C5),
																																			width: 2,
																																		),
																																		borderRadius: BorderRadius.circular(12),
																																		color: Color(0xFFF4F3F3),
																																	),
																																	padding: const EdgeInsets.symmetric(vertical: 15),
																																	margin: const EdgeInsets.only( right: 8),
																																	width: double.infinity,
																																	child: Column(
																																		children: [
																																			IntrinsicWidth(
																																				child: IntrinsicHeight(
																																					child: Column(
																																						children: [
																																							Container(
																																								decoration: BoxDecoration(
																																									borderRadius: BorderRadius.circular(12),
																																								),
																																								width: 22,
																																								height: 20,
																																								child: ClipRRect(
																																									borderRadius: BorderRadius.circular(12),
																																									child: Image.network(
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/vlp5oldj_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							IntrinsicWidth(
																																								child: IntrinsicHeight(
																																									child: Container(
																																										padding: const EdgeInsets.only( top: 4),
																																										child: Column(
																																											children: [
																																												Text(
																																													"Tambah",
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
																																	border: Border.all(
																																		color: Color(0xFFCFC4C5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFEEEEEE),
																																),
																																padding: const EdgeInsets.only( top: 1),
																																margin: const EdgeInsets.only( right: 9),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(12),
																																			),
																																			width: 72,
																																			height: 72,
																																			child: ClipRRect(
																																				borderRadius: BorderRadius.circular(12),
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/suj9pyns_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			)
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
																																	border: Border.all(
																																		color: Color(0xFFCFC4C5),
																																		width: 1,
																																	),
																																	borderRadius: BorderRadius.circular(12),
																																	color: Color(0xFFEEEEEE),
																																),
																																padding: const EdgeInsets.only( top: 1),
																																margin: const EdgeInsets.only( right: 8),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		Container(
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(12),
																																			),
																																			width: 72,
																																			height: 72,
																																			child: ClipRRect(
																																				borderRadius: BorderRadius.circular(12),
																																				child: Image.network(
																																					"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/xe7kosbh_expires_30_days.png",
																																					fit: BoxFit.fill,
																																				)
																																			)
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Expanded(
																														child: Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(12),
																															),
																															height: 69,
																															width: double.infinity,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(12),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/xk3TMtQ13L/em4x1lhc_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
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
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15, right: 15),
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
																							color: Color(0x1A000000),
																							blurRadius: 4,
																							offset: Offset(0, 2),
																						),
																					],
																				),
																				padding: const EdgeInsets.symmetric(vertical: 13),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Text(
																							"Kirim Ulasan",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 16,
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