import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../managers/type_manager.dart';

import 'introduction_card.dart';
import '../room_type/room_type_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _selectedCapacity;
  String? _selectedArea;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final typeManager = Provider.of<TypeManager>(context, listen: false);
      typeManager.fetchRoomTypes();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ánh Dương Hotel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh tìm kiếm và bộ lọc
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<TypeManager>(
                builder: (context, typeManager, child) {
                  // Lấy danh sách giá trị cho dropdown
                  final capacities = ['Tất cả'] +
                      typeManager.roomTypes
                          .map((type) => type.capacity.toString())
                          .toSet()
                          .toList();
                  final areas = ['Tất cả'] +
                      typeManager.roomTypes
                          .map((type) => type.area.toString())
                          .toSet()
                          .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                hintText: 'Tìm kiếm loại phòng...',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 16),
                                filled: true,
                                fillColor: Colors.grey[200],
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (query) {
                                _searchQuery = query; // Cập nhật từ khóa
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              // Bỏ focus khung tìm kiếm
                              _searchFocusNode.unfocus();

                              // Kết hợp tìm kiếm và bộ lọc
                              Provider.of<TypeManager>(context, listen: false)
                                  .searchRoomTypesWithFilters(
                                query: _searchQuery,
                                capacity: _selectedCapacity == 'Tất cả'
                                    ? null
                                    : _selectedCapacity,
                                area: _selectedArea == 'Tất cả'
                                    ? null
                                    : _selectedArea,
                              );
                            },
                            child:
                                const Icon(Icons.search, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Dropdown sức chứa
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCapacity,
                              items: capacities
                                  .map((capacity) => DropdownMenuItem(
                                        value: capacity,
                                        child: Text(capacity == 'Tất cả'
                                            ? capacity
                                            : "$capacity người"),
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                labelText: 'Sức chứa',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCapacity = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Dropdown diện tích
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedArea,
                              items: areas
                                  .map((area) => DropdownMenuItem(
                                        value: area,
                                        child: Text(area == 'Tất cả'
                                            ? area
                                            : "$area m²"),
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                labelText: 'Diện tích',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedArea = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // Đoạn giới thiệu

            const IntroductionCard(),

            // Danh sách các loại phòng
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: Text(
                  'Phòng',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<TypeManager>(
                builder: (context, typeManager, child) {
                  if (typeManager.filteredRoomTypes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không tìm thấy kết quả phù hợp.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: typeManager.filteredRoomTypes.map((roomType) {
                      return RoomTypeCard(
                        roomType: roomType,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/room_reservation');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
