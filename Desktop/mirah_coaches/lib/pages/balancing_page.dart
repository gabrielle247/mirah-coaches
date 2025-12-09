import 'package:flutter/material.dart';
import 'package:mirah_coaches/view_models/balancing_view_model.dart';
import 'package:provider/provider.dart';

class BalancingPage extends StatefulWidget {
  const BalancingPage({super.key});

  @override
  State<BalancingPage> createState() => _BalancingPageState();
}

late TabController _tabController;

class _BalancingPageState extends State<BalancingPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var subTitle = const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    ColorScheme appTheme = Theme.of(context).colorScheme;
    final balancingPage = Provider.of<BalancingViewModel>(context);
    // ignore: unused_local_variable
    final GlobalKey _menuKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: const Text("Journey Summary"),
        actions: [
              PopupMenuButton(
                
                itemBuilder: (context) => [
                  PopupMenuItem(value: 0, child: Text("Clear To")),
                  PopupMenuItem(value: 1, child: Text("Clear From")),
                  PopupMenuItem(value: 2, child: Text("Clear All")),
                ],

                icon: Icon(Icons.clear_all_rounded),
                onSelected: (value) => {},
                color: appTheme.primary,
          ),
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.blue.shade400,
          labelColor: Colors.blue.shade400,
          onTap: (index) => balancingPage.balancingPage(index),
          controller: _tabController,
          tabs: [getText("FROM"), getText("TO")],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Text("Tab 1", style: subTitle),
          Text("Tab 2", style: subTitle),
        ],
      ),
    );
  }
}

Tab getText(final String value) {
  return Tab(text: value);
}

//Tab 1
class FromTab extends StatelessWidget {
  const FromTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(),
        ),
      ],
    );
  }
}

//Tab 2
class ToTab extends StatelessWidget {
  const ToTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter()
      ],
    );
  }
}
