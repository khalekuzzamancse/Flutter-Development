part of core_ui;

class CostSection extends StatelessWidget {
  final String subTotal, vat, total;
  final Pair<double, String>? extraCharge;
  final Function? onExtraChargeRemoveRequest;
  /// Discount is optional so that it can be used with TakeAwayHome and CollectionDashboard.
  final String? discount;

  const CostSection({
    Key? key,
    required this.subTotal,
    required this.vat,
    required this.total,
    this.discount,
    this.extraCharge,
     this.onExtraChargeRemoveRequest
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 29, 81, 131),
      child: Column(
        children: [
          //TODO:Currently no discount option
          // CostRow(label: "Sub Total", value: subTotal),
          // CostRow(label: "Vat (Inc.tax)", value: vat),
          // if (extraCharge != null)
          //   ExtraChargeRow(
          //     amount: extraCharge!.first,
          //     reason: extraCharge!.second,
          //     onRemove: () {
          //       if(onExtraChargeRemoveRequest!=null) {
          //         onExtraChargeRemoveRequest!();
          //       }
          //     },
          //   ),
          // if (discount != null)CostRow(label: "Discount", value: discount!),
          CostRow(
            label: "Total Amount",
            value: total,
            backgroundColor: const Color.fromARGB(255, 44, 121, 194),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
class CostRow extends StatelessWidget {
  final String label;
  final String value;
  /// If provided, wraps the row in a container with this background color.
  final Color? backgroundColor;
  /// If true, a divider is shown below the row.
  final bool showDivider;

  const CostRow({
    Key? key,
    required this.label,
    required this.value,
    this.backgroundColor,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The row content is common.
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 0, 8),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 25, 5),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );

    // If a background color is specified, wrap the row in a container.
    final content = backgroundColor != null
        ? Container(
      color: backgroundColor,
      child: row,
    )
        : row;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (showDivider)
          const Divider(
            height: 1,
            color: Color.fromARGB(61, 255, 255, 255),
          ),
      ],
    );
  }
}
class ExtraChargeRow extends StatelessWidget {
  final String reason;
  final double amount;
  final VoidCallback? onRemove;

  const ExtraChargeRow({
    Key? key,
    required this.reason,
    required this.amount,
    this.onRemove,
  }) : super(key: key);

  void _showReason(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 0, 8),
                child: Row(
                  children: [
                    if (onRemove != null)
                      InkWell(
                        onTap: onRemove,
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    const SpacerHorizontal(8),
                    const Text(
                      "Extra Charge",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SpacerHorizontal(8),
                    if (onRemove != null)
                      InkWell(
                        onTap: () => _showReason(context),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 25, 5),
                child: Text(
                  amount.toString().toTwoDecimalOrOriginal(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 1,
          color: Color.fromARGB(61, 255, 255, 255),
        ),
      ],
    );
  }
}
