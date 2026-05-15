import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfe/core/localization/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe/core/theme/app_theme.dart';
import 'package:pfe/core/widgets/budget_card_home/budget_card_home.dart';
import 'package:pfe/core/widgets/card_home/card_home.dart';
import 'package:pfe/core/widgets/list_card_home/list_card_home.dart';
import 'package:pfe/core/widgets/search_bar/search_bar.dart';
import 'package:pfe/core/widgets/filtre_buttons/filterbutton.dart';
import 'package:pfe/core/widgets/header/header.dart';

import 'package:pfe/features/home/data/repositories/property_repository.dart';
import 'package:pfe/features/home/presentation/bloc/home_bloc.dart';
import 'package:pfe/features/home/presentation/bloc/home_event.dart';
import 'package:pfe/features/home/presentation/bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(PropertyRepository())..add(LoadProperties()),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER
              HeaderWidget(),

              const SizedBox(height: 20),

              // 🔹 SEARCH BAR
              Searchbar(),

              const SizedBox(height: 20),

              // 🔹 FILTER BUTTONS
              Row(
                children: [
                  Filterbutton(
                    active: true,
                    text: AppStrings.navExplore,
                    icon: Icons.search,
                  ),
                  const SizedBox(width: 10),
                  Filterbutton(
                    active: false,
                    text: AppStrings.filterNearMetro,
                    icon: Icons.subway,
                  ),
                  const SizedBox(width: 10),
                  Filterbutton(
                    active: false,
                    text: AppStrings.filterColiving,
                    icon: Icons.people_outline,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 🔹 DYNAMIC BLOC CONTENT
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(
                        'Failed to load properties: ${state.message}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is HomeLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 FEATURED LISTINGS
                        _sectionHeader(AppStrings.featuredListings),
                        const SizedBox(height: 12),

                        if (state.featuredProperties.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text('No featured listings available.'),
                          )
                        else
                          SizedBox(
                            height: 210,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.featuredProperties.length,
                              itemBuilder: (context, index) {
                                final prop = state.featuredProperties[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: CardHome(property: prop),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 24),

                        // 🔹 BUDGET CARD
                        BudgetCardHome(),

                        const SizedBox(height: 24),

                        // 🔹 CO-LIVING
                        _sectionHeader(AppStrings.bestForColiving),
                        const SizedBox(height: 12),

                        if (state.colivingProperties.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text('No co-living listings available.'),
                          )
                        else
                          ...state.colivingProperties.map((prop) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ListCardHome(property: prop),
                              )),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // 🔹 MAP BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.map),
        label: Text(AppStrings.mapButton),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.firaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          AppStrings.seeAll,
          style: GoogleFonts.firaSans(
            fontSize: 13,
            color: const Color(0xFF1E6AF0),
          ),
        ),
      ],
    );
  }
}
