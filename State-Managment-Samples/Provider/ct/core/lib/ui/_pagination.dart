
part of core_ui;

//@formatter:off
class _ControllerProvider extends InheritedWidget {
  final PaginationController controller;
  const _ControllerProvider({required this.controller, required Widget child}) : super(child: child);
  ///If controller not exit will throw exception
  static PaginationController getOrThrow(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ControllerProvider>()!.controller;
  @override
  bool updateShouldNotify(_ControllerProvider oldWidget)=>oldWidget.controller != controller;
}

class Pagination extends StatelessWidget {
  final PaginationController controller;
  const Pagination({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _ControllerProvider(
      controller:controller ,
      child: const _Pagination(),
    );
  }
}
class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _PaginationPage(),
         Spacer(),
        _TotalDisplay()
      ],
    );
  }
}


class _PaginationPage extends StatelessWidget {
  const _PaginationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = _ControllerProvider.getOrThrow(context);
      final int currentPage = controller.currentPage.value;
      final int totalPages = controller.totalPages.value;

      List<Widget> buildPageButtons() {
        List<Widget> pageButtons = [];

        if (totalPages <= 5) {
          // Show all pages if total is 5 or less
          for (int i = 1; i <= totalPages; i++) {
            pageButtons.add(
              PaginationButton(
                label: '$i',
                onPressed: i != currentPage ? () => controller.gotoPage(i) : null,
                isSelected: i == currentPage,
              ),
            );
          }
        } else {
          // Handle pagination with ellipsis
          if (currentPage > 3) {
            pageButtons.add(
              PaginationButton(
                label: '1',
                onPressed: () => controller.gotoPage(1),
              ),
            );

            if (currentPage > 4) {
              pageButtons.add(
                const PaginationButton(
                  label: '...',
                  onPressed: null, // Ellipsis is non-clickable
                  isSelected: false,
                ),
              );
            }
          }

          // Show 2 pages before and 2 after the current page
          for (int i = currentPage - 2; i <= currentPage + 2; i++) {
            if (i > 0 && i <= totalPages) {
              pageButtons.add(
                PaginationButton(
                  label: '$i',
                  onPressed: i != currentPage ? () => controller.gotoPage(i) : null,
                  isSelected: i == currentPage,
                ),
              );
            }
          }

          if (currentPage < totalPages - 2) {
            pageButtons.add(
              const PaginationButton(
                label: '...',
                onPressed: null, // Ellipsis is non-clickable
                isSelected: false,
              ),
            );
            pageButtons.add(
              PaginationButton(
                label: '$totalPages',
                onPressed: () => controller.gotoPage(totalPages),
              ),
            );
          }
        }

        return pageButtons;
      }

      return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0,
          children: [
            if (totalPages > 0)
              PaginationButton(
                label: "Previous",
                onPressed: currentPage > 1 ? controller.gotoPrevPage : null,
              ),
            ...buildPageButtons(),
            if (totalPages >= 1)
              PaginationButton(
                label: "Next",
                onPressed: currentPage < totalPages ? controller.gotoNextPage : null,
              ),
          ],
        ),
      );
    });


    // return Obx((){
   //    final controller = _ControllerProvider.getOrThrow(context);
   //    final int currentPage = controller.currentPage.value;
   //    final int totalPages = controller.totalPages.value;
   //    return  Align(
   //      alignment: Alignment.centerLeft,
   //      child: Wrap(
   //        alignment: WrapAlignment.start,
   //        spacing: 8.0,
   //        children: [
   //          if(totalPages>0)
   //          PaginationButton(
   //            label: "Previous",
   //            onPressed: currentPage > 1 ? controller.gotoPrevPage : null,
   //          ),
   //          for (int i = 1; i <= totalPages; i++)
   //            PaginationButton(
   //              label: '$i',
   //              onPressed: i != currentPage ? () => controller.gotoPage(i) : null,
   //              isSelected: i == currentPage,
   //            ),
   //          if(totalPages>=1)
   //          PaginationButton(
   //            label: "Next",
   //            onPressed: currentPage < totalPages ? controller.gotoNextPage : null,
   //          ),
   //        ],
   //      ),
   //    );
   //  });


  }
}

class PaginationButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;

  const PaginationButton({
    required this.label,
    this.onPressed,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.grey
              : const Color.fromARGB(255, 30, 84, 134),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: Colors.white, width: 0.4),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}


class Ellipsis extends StatelessWidget {
  const Ellipsis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '...',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
class _TotalDisplay extends StatelessWidget {
  const _TotalDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = _ControllerProvider.getOrThrow(context);
    const style = TextStyle(color: Colors.white);
    return Obx((){
      final int totalValue = controller.totalItem.value;
      return Text(
        'Total: $totalValue',
        style: style,
      );
    });
  }
}

