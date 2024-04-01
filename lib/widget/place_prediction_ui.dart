// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/global/map_key.dart';
import 'package:quickmed/method/common_method.dart';
import 'package:quickmed/model/direction_model.dart';
import 'package:quickmed/model/place_prediction.dart';
import 'package:quickmed/provider/app_info.dart';
import 'package:quickmed/widget/loading_dialog.dart';


class PredictionPlaceUI extends StatefulWidget
{
  PredictionModel? predictedPlaceData;

  PredictionPlaceUI({super.key, this.predictedPlaceData,});

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlaceUIState();
}

class _PredictionPlaceUIState extends State<PredictionPlaceUI>
{
  ///Place Details - Places API
  fetchClickedPlaceDetails(String placeID) async
  {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LoadingDialog(messageText: "Getting details..."),
    );

    String urlPlaceDetailsAPI = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey";

    var responseFromPlaceDetailsAPI = await CommonMethods.sendRequestToAPI(urlPlaceDetailsAPI);

    Navigator.pop(context);

    if(responseFromPlaceDetailsAPI == "error")
    {
      return;
    }

    if(responseFromPlaceDetailsAPI["status"] == "OK")
    {
      AddressModel dropOffLocation = AddressModel();

      dropOffLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      dropOffLocation.latitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      dropOffLocation.longitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];
      dropOffLocation.placeID = placeID;

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocation(dropOffLocation);
      
      Navigator.pop(context, "placeSelected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()
      {
        fetchClickedPlaceDetails(widget.predictedPlaceData!.place_id.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: SizedBox(
        child: Column(
          children: [

            const SizedBox(height: 10,),

            Row(
              children: [

                const Icon(
                  Icons.share_location,
                  color: Colors.grey,
                ),

                const SizedBox(width: 13,),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text(
                        widget.predictedPlaceData!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 3,),

                      Text(
                        widget.predictedPlaceData!.secondary_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}
