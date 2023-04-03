import uuid
import subprocess
import dash
from dash import html
from dash import dcc
from dash.dependencies import Output, Input, State
import plotly.graph_objects as go
import base64
import tempfile
import scipy.io.wavfile as wav
import numpy as np
external_stylesheets = [
    'https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css',
]

uploader = html.Div([
    html.Div(
        dcc.Upload(
            id='upload-data',
            children=[html.H1('Gerber to STL converter'), 'Drop a Gerber, and this will convert it to an STL', html.A('Select Files')],
            style={
                'width': '100%',
                'height': '60px',
                'lineHeight': '60px',
                'borderWidth': '1px',
                'borderStyle': 'dashed',
                'borderRadius': '5px',
                'textAlign': 'center',
                'margin': '10px'
            },
            # Allow multiple files to be uploaded
            multiple=False),
        className="col")],
    className="row")
            

settings = html.Div(
    [
        html.Div(
            [
            ],
            className="col")
    ],
    className="row"
)
downloader = html.Div(
    [dcc.Download(id="downloader")]
    )

plot_pane = [uploader, downloader, settings]

plotter_layout = html.Div(plot_pane, className="container")

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
app.layout = plotter_layout
server=app.server

@app.callback(Output('downloader', 'data'),
              [
                  Input('upload-data', 'contents'),
              ],
              [State('upload-data', 'filename')])
def update_output(list_of_contents, list_of_fn):
    if list_of_contents is None:
        return None
    else:
        results = ""
        #        for contents, fn in zip(list_of_contents, list_of_fn):
        contents, fn = list_of_contents, list_of_fn
        output_fn = f'/tmp/{uuid.uuid4()}.stl'
        with tempfile.NamedTemporaryFile() as tempfn:
            content_type, content_string = contents.split(",")
            binary_data = base64.b64decode(content_string)
            tempfn.write(binary_data)
            tempfn.flush()
            name = tempfn.name
            r = subprocess.run(['python', '/app/gerber2stl.py', name, output_fn])
            results = open(output_fn, "r").read()
            print("Yay!  Returning a file of length {len(results)}")
            return dict(content=results, filename=f'{fn}.stl')


if __name__ == '__main__':
    app.run_server(debug=True, host="0.0.0.0")
