import 'package:cached_network_image/cached_network_image.dart';
import 'package:diapce/Widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controllers/project_controller.dart';
import '../Models/project.dart';
import '../Providers/auth_provider.dart';
import '../Providers/project_provider.dart';
import '../Widgets/sliver_app_delegate.dart';
import '../Widgets/text_widget.dart';
import 'project_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //variables
    final ScrollController _scrollController = ScrollController();
    final ProjectController _projectController = ProjectController();
    double appBarOpacity = 1.0;

    @override
    void initState() {
      super.initState();
      _projectController.index(context);
      _scrollController.addListener(() {
        double offset = _scrollController.offset;
        appBarOpacity = offset <= 100 ? 1.0 : 0.0;
        setState(() {});
      });
    }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(auth),
            _buildTitle(),
            _buildList(),

          ],
        ),
    );
  }

  SliverPersistentHeader _buildSliverAppBar(AuthProvider auth) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
          minHeight: 125,
          maxHeight: 350,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/fondo3.jpg'),
                        fit: BoxFit.cover)),
              ),
              Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Search(),
                    Expanded(
                      child: Opacity(
                        opacity: appBarOpacity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            TextWidget(
                              text: 'Hola, ${auth.name}',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            TextWidget(
                              text: '¡Estos son tus proyectos actuales!',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ))
                  ],
                ),
              )
            ],
          )),
    );
  }

  //Sliver for title
  SliverToBoxAdapter _buildTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: TextWidget(text: 'Tus proyectos', fontSize: 12, color: Colors.grey),
      )
    );
  }

  SliverList _buildList() {
    final projectProvier = Provider.of<ProjectProvider>(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildCardProyect(projectProvier.projects[index]);
        },
        childCount: projectProvier.projects.length,
      ),
    );
  }

  // Sliver for card Proyect
  Widget _buildCardProyect(ProjectModel project) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetails(project: project)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget(text: project.name, fontSize: 14, fontWeight: FontWeight.w500),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 16),
                )
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                imageUrl: project.url,
                placeholder: (context, url) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return _buildNotFound();
                },
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/images/notfound.jpg', width: 200))
    );
  }
}
